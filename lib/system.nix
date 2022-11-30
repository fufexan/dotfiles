inputs: rec {
  supportedSystems = ["aarch64-linux" "x86_64-linux"];

  genSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;

  pkgs = genSystems (system:
    import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      config.overlays = [
        (
          _: prev: {
            steam = prev.steam.override {
              extraPkgs = pkgs:
                with pkgs; [
                  keyutils
                  libkrb5
                  libpng
                  libpulseaudio
                  libvorbis
                  stdenv.cc.cc.lib
                  xorg.libXcursor
                  xorg.libXi
                  xorg.libXinerama
                  xorg.libXScrnSaver
                ];
              extraProfile = "export GDK_SCALE=2";
            };
          }
        )
      ];
    });
}
