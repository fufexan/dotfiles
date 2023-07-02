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
    url = "https://images.unsplash.com/photo-1529840882932-55f06ab2c681";
    sha256 = "1xngx610skv1vqzx1c7j2zv5cg3gld3hkcxki8jd30rssjjx98p2";
  };
}
