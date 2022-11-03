{
  pkgs,
  lib,
  config,
  ...
}:
# manage files in ~
{
  home.file.".config" = {
    source = ./config;
    recursive = true;
  };

  # wallpaper
  xdg.configFile = {
    "wallpaper.png".source = builtins.fetchurl rec {
      name = "wallpaper-${sha256}.png";
      url = "https://9to5mac.com/wp-content/uploads/sites/6/2014/08/yosemite-4.jpg?quality100&strip=all";
      sha256 = "1hvpphvrdnlrdij2armq5zpi5djg2wj7hxhg148cgm9fs9m3z1vq";
    };
  };

  # Product Sans font
  home.file."${config.xdg.dataHome}/fonts/ProductSans".source = lib.cleanSourceWith {
    filter = name: _: (lib.hasSuffix ".ttf" (baseNameOf (toString name)));
    src = pkgs.fetchzip {
      url = "https://befonts.com/wp-content/uploads/2018/08/product-sans.zip";
      sha256 = "sha256-PF2n4d9+t1vscpCRWZ0CR3X0XBefzL9BAkLHoqWFZR4=";
      stripRoot = false;
    };
  };
}
