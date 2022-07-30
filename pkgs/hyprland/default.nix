inputs: prev: let
  hp = inputs.hyprland.packages.${prev.system};

  hyprland = hp.default.override {
    wlroots = (hp.wlroots-hyprland.override {inherit xwayland;}).overrideAttrs (_: {
      patches = [
        (prev.fetchpatch {
          url = "https://gitlab.freedesktop.org/lilydjwg/wlroots/-/commit/6c5ffcd1fee9e44780a6a8792f74ecfbe24a1ca7.diff";
          sha256 = "sha256-Eo1pTa/PIiJsRZwIUnHGTIFFIedzODVf0ZeuXb0a3TQ=";
        })
      ];
    });
    inherit xwayland;
  };

  xwayland = prev.xwayland.overrideAttrs (_: {
    patches = [
      ../patches/xwayland-vsync.patch
      ../patches/xwayland-hidpi.patch
    ];
  });
in
  hyprland
