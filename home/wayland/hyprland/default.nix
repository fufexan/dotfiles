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
in {
  home.packages = with pkgs; [
    apply-hm-env
    wf-recorder
    swayidle
    xorg.xprop
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
  ];

  home.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    GDK_SCALE = "2";
  };

  services.swayidle = {
    enable = false;
    events = [
      {
        event = "before-sleep";
        command = "gtklock";
      }
      {
        event = "lock";
        command = "gtklock";
      }
    ];
    timeouts = [
      {
        timeout = 300;
        command = "hyprctl dispatch dpms off";
        resumeCommand = "hyprctl dispatch dpms on";
      }
      {
        timeout = 310;
        command = "loginctl lock-session";
      }
    ];
  };
  systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = import ./config.nix args;
  };
}
