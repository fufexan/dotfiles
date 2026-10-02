{ lib, ... }: {
  theme = {
    wallpaper =
      let
        url = "https://images.unsplash.com/photo-1673368777914-a3bdac42c5e0?ixlib=rb-4.1.0&q=100&fm=jpg&cs=srgb&dl=rafael-garcin-L7sDY9KL9G8-unsplash.jpg";
        sha256 = "sha256-K6ksD7ylUzuHGk7MxdcLUSkM5PAx0Qm/R8yLWyDs8c8=";
        ext = "jpg";
      in
      builtins.fetchurl {
        name = "wallpaper-${lib.strings.sanitizeDerivationName sha256}.${ext}";
        inherit url sha256;
      };
  };
}
