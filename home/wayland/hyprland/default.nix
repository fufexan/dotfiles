{
  config,
  inputs,
  lib,
  pkgs,
  ...
} @ args: let
  apply-hm-env = pkgs.writeShellScriptBin "apply-hm-env" ''
    ${lib.optionalString (config.home.sessionPath != []) ''
      export PATH=${builtins.concatStringsSep ":" config.home.sessionPath}:$PATH
    ''}
    ${builtins.concatStringsSep "\n" (lib.mapAttrsToList (k: v: ''
        export ${k}=${v}
      '')
      config.home.sessionVariables)}
    ${config.home.sessionVariablesExtra}
    exec "$@"
  '';

  screenshot = import ../screenshot.nix args;
in {
  home.packages = with pkgs; [
    screenshot
    wf-recorder
    xorg.xprop
    apply-hm-env
  ];

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "swaylock -fF";
      }
      {
        event = "lock";
        command = "swaylock -fF";
      }
    ];
    timeouts = [
      {
        timeout = 20;
        command = "hyprctl dispatch dpms off";
        resumeCommand = "hyprctl dispatch dpms on";
      }
      {
        timeout = 30;
        command = "swaylock -fF";
      }
    ];
  };
  systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.self.packages.${pkgs.system}.hyprland;
    extraConfig = import ./config.nix args;
  };
}
