lib: {
  browser = "firefox";
  launcher = "anyrun";

  terminal = {
    font = "JetBrainsMono Nerd Font";
    name = "wezterm";
    opacity = 0.9;
    size = 10;
  };

  wallpaper = let
    params = "?q=85&fm=jpg&crop=fit&cs=srgb&w=2560";
    url = "https://images.unsplash.com/photo-1608507974219-2df72d775da0${params}.jpg";
    sha256 = "0dr4svc3sbygkxyrjxillrdx4940rvw0avf2grrrx2l88z64srmq";
    ext = lib.last (lib.splitString "." url);
  in
    builtins.fetchurl {
      name = "wallpaper-${sha256}.${ext}";
      inherit url sha256;
    };
}
