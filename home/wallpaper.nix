{
  self,
  lib,
  ...
}:
let
  wallpapers = self.packages.x86_64-linux.wallpapers;
in
{
  options.theme.wallpaper = {
    dark = lib.mkOption {
      type = lib.types.str;
      description = "Wallpaper used in dark mode (default).";
    };
    light = lib.mkOption {
      type = lib.types.str;
      description = "Wallpaper used in light mode.";
    };
  };

  config.theme.wallpaper = {
    dark = "${wallpapers}/dark.jpg";
    light = "${wallpapers}/light.jpg";
  };
}
