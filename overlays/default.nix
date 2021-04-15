final: prev: {
  hunter = prev.callPackage ./hunter {
    inherit (prev.darwin.apple_sdk.frameworks) IOKit;
  };
  wine-osu = prev.callPackage ./wine-osu { };
}
