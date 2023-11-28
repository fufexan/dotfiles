lib: {
  browser = "firefox";
  launcher = "anyrun";

  terminal = {
    font = "JetBrainsMono Nerd Font";
    name = "foot";
    opacity = 0.9;
    size = 10;
  };

  wallpaper = let
    size = "&w=2560&h=1600";
    url = "https://images.unsplash.com/photo-1690460550070-e73402127f11?ixlib=rb-4.0.3&q=85&fm=jpg&crop=entropy&cs=srgb&dl=marlon-medau-TFg35jn95OU-unsplash${size}.jpg";
    sha256 = "0w2rp7km4r6wq8jihfyh36g76c0s1jcidpv4q2c2yl7mrs8gfj27";
    ext = lib.last (lib.splitString "." url);
  in
    builtins.fetchurl {
      name = "wallpaper-${sha256}.${ext}";
      inherit url sha256;
    };
}
