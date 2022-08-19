# manage files in ~
{
  home.file.".config" = {
    source = ./config;
    recursive = true;
  };

  xdg.configFile = {
    "wallpaper.jpg".source = builtins.fetchurl {
      name = "WavyLines02.jpg";
      url = "https://raw.githubusercontent.com/catppuccin/wallpapers/main/waves/wavy_lines_v02_5120x2880.png";
      sha256 = "0b5bi27kjsiwjj4d4pcjnmm9ysscnhgwyd0qm40jsypp7zh78fb9";
    };
  };
}
