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
      sha256 = "1yha3fbr7if2pmq9ylrcshnf8cmcz1r9whmr3b95kdgan0mm0pbz";
    };
  };
}
