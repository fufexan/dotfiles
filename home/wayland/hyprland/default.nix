{
  pkgs,
  inputs,
  ...
} @ args: {
  home.packages = [inputs.hyprland.packages.${pkgs.system}.default];

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
