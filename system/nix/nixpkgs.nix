{ self, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
    config.permittedInsecurePackages = [ "olm-3.2.16" ];

    overlays = [
      (final: prev: {
        linuxPackages_latest = prev.linuxPackages_latest.extend (
          _: lpprev: {
            ddcci-driver = lpprev.ddcci-driver.overrideAttrs (old: {
              patches = (old.patches or [ ]) ++ [
                # allows detection even if monitor does not report itself as such
                "${self}/pkgs/ddcci-fix-missing-tags.patch"
                # retry core device detection so brightness works from boot
                # instead of only after a manual module reload (DDC/CI isn't
                # responsive yet when the udev rule instantiates the device)
                "${self}/pkgs/ddcci-probe-retry.patch"
              ];
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
                hash = "sha256-aQmqLpM0vogMsYaDS9OeKVI3N53uY4NBC4FF10hK8Uw=";
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
