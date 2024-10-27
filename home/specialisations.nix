{
  theme = {
    wallpaper = let
      url = "https://github.com/saint-13/Linux_Dynamic_Wallpapers/blob/main/Dynamic_Wallpapers/ChromeOSWind/ChromeOSWind-2.png?raw=true";
      sha256 = "0j4m3azrwgfh3rahmasv4c8pr40x1brbn77nx54hpmg8pb9i67cc";
      ext = "png";
    in
      builtins.fetchurl {
        name = "wallpaper-${sha256}.${ext}";
        inherit url sha256;
      };
  };
}
