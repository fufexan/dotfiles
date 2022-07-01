{
  config,
  inputs,
  lib,
  pkgs,
  ...
} @ args: let
  swayidleCfg = config.systemd.user.services.swayidle.Install.WantedBy;
in {
  home.packages = [pkgs.hyprland];

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
