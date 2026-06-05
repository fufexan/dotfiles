{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  lock = "${pkgs.systemd}/bin/loginctl lock-session";
  dpms = action: ''hyprctl dispatch 'hl.dsp.dpms({action = "${action}"})'';

  brillo = lib.getExe pkgs.brillo;

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
          # save the current brightness and dim the screen over a period of
          # 500 ms
          on-timeout = "${brillo} -O; ${brillo} -u 500000 -S 10";
          # brighten the screen over a period of 250ms to the saved value
          on-resume = "${brillo} -I -u 250000";
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
