{
  config,
  inputs,
  lib,
  pkgs,
  ...
} @ args: let
  swayidleCfg = config.systemd.user.services.swayidle.Install.WantedBy;

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
    inputs.self.packages.${pkgs.system}.hyprland

    grim
    libnotify
    light
    playerctl
    pulsemixer
    screenshot
    slurp
    swappy
    wf-recorder
    wl-clipboard
    wlogout

    apply-hm-env
  ];

  xdg.configFile."hypr/hyprland.conf".text = import ./config.nix args;

  # allow swayidle to be started along with Hyprland
  systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["sway-session.target" "hyprland-session.target"];

  systemd.user.targets.hyprland-session = {
    Unit = {
      Description = "hyprland compositor session";
      Documentation = ["man:systemd.special(7)"];
      BindsTo = ["graphical-session.target"];
      Wants = ["graphical-session-pre.target"];
      After = ["graphical-session-pre.target"];
    };
  };
}
