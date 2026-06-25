{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  lock = "${pkgs.systemd}/bin/loginctl lock-session";
  dpms = action: ''hyprctl dispatch 'hl.dsp.dpms({action = "${action}"})''\''';

  # timeout after which DPMS kicks in
  timeout = 300;
in
{
  # screen idle
  services.hypridle = {
    enable = true;

    package = inputs.hypridle.packages.${pkgs.stdenv.hostPlatform.system}.hypridle;

    settings = {
      general = {
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = dpms "enable";
        lock_cmd = "pgrep hyprlock || ${lib.getExe config.programs.hyprlock.package}";
      };

      listener = [
        {
          timeout = timeout - 10;
          # idle-brightness package from system/hardware/brightness.nix
          # save the current brightness and dim the screen
          on-timeout = "idle-brightness low";
          # brighten the screen
          on-resume = "idle-brightness high";
        }
        {
          inherit timeout;
          on-timeout = dpms "disable";
          on-resume = dpms "enable";
        }
        {
          timeout = timeout + 10;
          on-timeout = lock;
        }
      ];
    };
  };
}
