prev: let
  sway-hidpi = prev.sway.override {
    inherit sway-unwrapped;
    withGtkWrapper = true;
  };

  sway-unwrapped =
    (prev.sway-unwrapped.overrideAttrs (oa: {
      src = prev.fetchFromGitHub {
        owner = "swaywm";
        repo = "sway";
        rev = "8d8a21c9c321fa41b033caf9b5b62cdd584483c1";
        sha256 = "sha256-WRvJsSvDv2+qirqkpaV2c7fFOgJAT3sXxPtKLure580=";
      };

      buildInputs = oa.buildInputs ++ [prev.pcre2 prev.xorg.xcbutilwm];
    }))
    .override {wlroots_0_16 = wlroots-sway;};

  wlroots-sway =
    (prev.wlroots.overrideAttrs (_: {
      src = prev.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "wlroots";
        repo = "wlroots";
        rev = "add44b3e2e4ff7ef98b16813fb3c9e1d8b398008";
        sha256 = "sha256-/fJGHeDuZ9aLjCSxILqNSm2aMrvlLZMZpx/WzX5A/XU=";
      };

      patches = [
        (prev.fetchpatch {
          url = "https://gitlab.freedesktop.org/lilydjwg/wlroots/-/commit/6c5ffcd1fee9e44780a6a8792f74ecfbe24a1ca7.diff";
          sha256 = "sha256-Eo1pTa/PIiJsRZwIUnHGTIFFIedzODVf0ZeuXb0a3TQ=";
        })
        (prev.fetchpatch {
          url = "https://gitlab.freedesktop.org/wlroots/wlroots/-/commit/18595000f3a21502fd60bf213122859cc348f9af.diff";
          sha256 = "sha256-jvfkAMh3gzkfuoRhB4E9T5X1Hu62wgUjj4tZkJm0mrI=";
          revert = true;
        })
      ];
    }))
    .override {inherit xwayland;};

  xwayland = prev.xwayland.overrideAttrs (_: {
    patches = [
      ./patches/xwayland-vsync.patch
      ./patches/xwayland-hidpi.patch
    ];
  });
in
  sway-hidpi
