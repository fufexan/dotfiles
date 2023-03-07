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

  terminal = {
    font = "JetBrainsMono Nerd Font";
    name = "wezterm";
    opacity = 0.9;
    size = 11;
  };

  wallpaper = builtins.fetchurl rec {
    name = "wallpaper-${sha256}.png";
    url = "https://raw.githubusercontent.com/catppuccin/wallpapers/main/misc/waves_right_colored.png";
    sha256 = "1nc78cdnwskkrcvfyj0s85a9sjyldv6fmz6iia08a257j7x89ain";
  };
}
