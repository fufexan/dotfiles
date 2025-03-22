{
  theme = {
    wallpaper = let
      url = "https://images.unsplash.com/photo-1529528744093-6f8abeee511d?ixlib=rb-4.0.3&q=85&fm=jpg&crop=fit&cs=srgb&width=2560.jpg";
      sha256 = "00v40dxc0l266hmjcdp3c3yw7l8qmz46aw2z6nqj5dvw6vmd6xfj";
      ext = "jpg";
    in
      builtins.fetchurl {
        name = "wallpaper-${sha256}.${ext}";
        inherit url sha256;
      };
  };
}
