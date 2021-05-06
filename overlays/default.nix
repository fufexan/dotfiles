final: prev: {
  shellac-server = prev.callPackage ./shellac-server { };
  wine-osu = prev.callPackage ./wine-osu { };
}
