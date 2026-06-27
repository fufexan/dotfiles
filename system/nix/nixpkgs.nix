{ self, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
    config.permittedInsecurePackages = [ "olm-3.2.16" ];

    overlays = [
      (final: prev: {
        grim = prev.grim.overrideAttrs (
          _: super:
          let
            grim-patch = final.fetchFromGitHub {
              owner = "thequantumcog";
              repo = "grim-patch";
              rev = "a1671f3e782ec677d168612ae8287dc55be0b5d4";
              hash = "sha256-g7Rkp63ZBJp7DB+t38hQMCgsWM89uS6d4etaOkHa/XI=";
            };
          in
          {
            # Adds patch that fixes blurry screenshots
            # https://github.com/thequantumcog/grim-patch
            # Adapted from https://lists.sr.ht/~emersion/grim-dev/patches/56912
            patches = (super.patches or [ ]) ++ [ "${grim-patch}/hyprland.patch" ];
          }
        );

        linuxPackages_latest = prev.linuxPackages_latest.extend (
          _: lpprev: {
            ddcci-driver = lpprev.ddcci-driver.overrideAttrs (old: {
              # allows detection even if monitor does not report itself as such
              patches = (old.patches or [ ]) ++ [ "${self}/pkgs/ddcci-fix-missing-tags.patch" ];
            });
          }
        );

        kdePackages = prev.kdePackages.overrideScope (
          kdeFinal: kdePrev: {
            qt6ct = kdePrev.qt6ct.overrideAttrs (old: {
              version = "git";

              src = final.fetchFromGitLab {
                domain = "www.opencode.net";
                owner = "trialuser";
                repo = "qt6ct"; # "https://www.opencode.net/trialuser/qt6ct.git";
                rev = "00823e41aa60e8fe266d5aee328e82ad1ad94348";
                hash = "";
              };

              buildInputs =
                (old.buildInputs or [ ])
                ++ (with kdeFinal; [
                  kconfig
                  kcolorscheme
                  kiconthemes
                ]);

              patches = (old.patches or [ ]) ++ [ "${self}/pkgs/qt6ct.patch" ];
            });
          }
        );

        lib = prev.lib // {
          colors = import "${self}/lib/colors" prev.lib;
        };
      })
    ];
  };
}
