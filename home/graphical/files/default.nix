# manage files in ~
{
  home.file.".config" = {
    source = ./config;
    recursive = true;
  };

  xdg.configFile = {
    "wallpaper.png".source = builtins.fetchurl rec {
      name = "wallpaper-${sha256}.png";
      url = "https://9to5mac.com/wp-content/uploads/sites/6/2014/08/yosemite-4.jpg?quality100&strip=all";
      sha256 = "1hvpphvrdnlrdij2armq5zpi5djg2wj7hxhg148cgm9fs9m3z1vq";
    };
  };
}
