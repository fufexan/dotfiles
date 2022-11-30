{inputs, ...}:
# personal lib
let
  inherit (inputs.nixpkgs) lib;

  colorlib = import ./colors.nix lib;
  default = import ./theme {inherit colorlib lib;};
in {
  imports = [
    {_module.args = {inherit default;};}
  ];

  perSystem = {system, ...}: {
    legacyPackages = import inputs.nixpkgs {
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
    };
  };
}
# adding nixpkgs lib is ugly but easier to keep track of things

