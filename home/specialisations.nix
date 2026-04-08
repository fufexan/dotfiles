{
  theme = {
    wallpaper =
      let
        url = "https://images.unsplash.com/photo-1529528744093-6f8abeee511d?ixlib=rb-4.0.3&q=85&fm=jpg&crop=fit&cs=srgb&w=2560";
        sha256 = "sha256-G+Fjy3ooUzHI5V8KN5Zb1JS51ktIFsur1N5F+n6FJaM=";
        ext = "jpg";
      in
      builtins.fetchurl {
        name = "wallpaper-${sha256}.${ext}";
        inherit url sha256;
      };
  };
}
