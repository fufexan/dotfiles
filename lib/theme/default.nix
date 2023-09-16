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
    url = "https://images.unsplash.com/photo-1690460550070-e73402127f11?ixlib=rb-4.0.3&q=85&fm=jpg&crop=entropy&cs=srgb&dl=marlon-medau-TFg35jn95OU-unsplash.jpg";
    sha256 = "18cyaxq4bw6qd79yvjgq4nsxspy0jwq88dy00z92whm5d13ckvgm";
    ext = lib.last (lib.splitString "." url);
  in
    builtins.fetchurl {
      name = "wallpaper-${sha256}.${ext}";
      inherit url sha256;
    };
}
