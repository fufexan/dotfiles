# manage files in ~
{
  home.file.".config" = {
    source = ./config;
    recursive = true;
  };

  xdg.configFile = {
    "wallpaper.png".source = builtins.fetchurl rec {
      name = "wallpaper-${sha256}.png";
      url = "https://raw.githubusercontent.com/catppuccin/wallpapers/main/landscapes/yosemite.png";
      sha256 = "sha256-k1kikLv9wiubFhemFiW5NN4pMqMmHHhSwqs3AzeD138=";
    };
  };
}
