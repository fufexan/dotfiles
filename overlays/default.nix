final: prev: {
  hunter = prev.callPackage ./hunter {
    inherit (prev.darwin.apple_sdk.frameworks) IOKit;
  };
  shellac-server = prev.callPackage ./shellac-server { };
  wine-osu = prev.callPackage ./wine-osu { };
}
