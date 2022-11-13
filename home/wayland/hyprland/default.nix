{
  config,
  inputs,
  lib,
  pkgs,
  ...
} @ args: let
  # needed for transient systemd services
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
in {
  home.packages = with pkgs; [
    apply-hm-env
    wf-recorder
    swayidle
    xorg.xprop
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
  ];

  home.sessionVariables = {
    # make screensharing work
    XDG_SESSION_TYPE = "wayland";
    # upscale steam
    GDK_SCALE = "2";
  };

  # screen idle
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
      }
      {
        event = "lock";
        command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
      }
    ];
    timeouts = [
      {
        timeout = 300;
        command = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms off";
        resumeCommand = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms on";
      }
      {
        timeout = 310;
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
    ];
  };

  # start swayidle as part of hyprland, not sway
  systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];

  # enable hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = import ./config.nix args;
  };
}
