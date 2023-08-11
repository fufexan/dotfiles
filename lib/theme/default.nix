{
  colorlib,
  lib,
}: rec {
  colors = import ./colors.nix;
  # #RRGGBB
  xcolors = lib.mapAttrs (_: colorlib.x) colors;
  # rgba(,,,) colors (css)
  rgbaColors = lib.mapAttrs (_: colorlib.rgba) colors;

  browser = "firefox";

  launcher = "anyrun";

  terminal = {
    font = "JetBrainsMono Nerd Font";
    name = "wezterm";
    opacity = 0.9;
    size = 10;
  };

  wallpaper = builtins.fetchurl rec {
    name = "wallpaper-${sha256}.png";
    url = "https://images.unsplash.com/photo-1525838983331-f8bd3c000585?ixlib=rb-4.0.3&q=85&fm=jpg&crop=entropy&cs=srgb&dl=andre-benz-sLokLIacItI-unsplash.jpg";
    sha256 = "04dqprjnh5bvp5afiq8p9flda30m77674a5ypjpwgr9pyvgvd099";
  };
}
