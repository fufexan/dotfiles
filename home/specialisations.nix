{
  theme = {
    wallpaper =
      let
        url = "https://images.unsplash.com/photo-1529528744093-6f8abeee511d?ixlib=rb-4.0.3&q=85&fm=jpg&crop=fit&cs=srgb&w=2560";
        sha256 = "sha256-JD4cHpKJS8gIee+APcFp54+o6IdwPZXOU6RHTf1hkY8=";
        ext = "jpg";
      in
      builtins.fetchurl {
        name = "wallpaper-${sha256}.${ext}";
        inherit url sha256;
      };
  };
}
