{
  inputs,
  withSystem,
  ...
}:
# personal lib
let
  inherit (inputs.nixpkgs) lib;

  colorlib = import ./colors.nix lib;
  default = import ./theme {inherit colorlib lib;};
in {
  imports = [
    {
      _module.args = {
        inherit default;
      };
    }
  ];

  perSystem = {system, ...}: {
    legacyPackages = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
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

            greetd =
              prev.greetd
              // {
                regreet = prev.greetd.regreet.overrideAttrs (oldAttrs: rec {
                  version = "main";
                  src = prev.fetchFromGitHub {
                    owner = "rharish101";
                    repo = "ReGreet";
                    rev = "61d871a0ee5c74230dfef8100d0c9bc75b309203";
                    hash = "sha256-PkQTubSm/FN3FXs9vBB3FI4dXbQhv/7fS1rXkVsTAAs=";
                  };
                  cargoDeps = oldAttrs.cargoDeps.overrideAttrs (_: {
                    inherit src;
                    outputHash = "sha256-dR6veXCGVMr5TbCvP0EqyQKTG2XM65VHF9U2nRWyzfA=";
                  });

                  # debug only
                  patches = [./patch.patch];
                });
              };

            clightd = prev.clightd.overrideAttrs (old: {
              version = "5.9";
              src = prev.fetchFromGitHub {
                owner = "FedeDP";
                repo = "clightd";
                rev = "e273868cb728b9fd0f36944f6b789997e6d74323";
                hash = "sha256-0NYWEJNVDfp8KNyWVY8LkvKIQUTq2MGvKUGcuAcl82U=";
              };
            });
          }
        )
      ];
    };
  };
}
