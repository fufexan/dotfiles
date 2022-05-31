{
  pkgs,
  inputs,
  ...
} @ args: {
  home.packages = [pkgs.hyprland];

  xdg.configFile."hypr/hyprland.conf".text = import ./config.nix args;

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
