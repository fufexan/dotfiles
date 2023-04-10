inputs: prev: let
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
    .override {wlroots_0_16 = inputs.hyprland.packages.${prev.system}.wlroots-hyprland;};
in
  sway-hidpi
