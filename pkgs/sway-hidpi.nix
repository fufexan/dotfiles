pkgs: let
  sway-hidpi = pkgs.sway.override {
    inherit sway-unwrapped;
    withGtkWrapper = true;
  };

  sway-unwrapped =
    (pkgs.sway-unwrapped.overrideAttrs (oa: {
      src = pkgs.fetchFromGitHub {
        owner = "swaywm";
        repo = "sway";
        rev = "8d8a21c9c321fa41b033caf9b5b62cdd584483c1";
        sha256 = "sha256-WRvJsSvDv2+qirqkpaV2c7fFOgJAT3sXxPtKLure580=";
      };

      buildInputs = oa.buildInputs ++ [pkgs.pcre2 pkgs.xorg.xcbutilwm];

      patches =
        oa.patches
        ++ [
          (pkgs.fetchpatch {
            url = "https://patch-diff.githubusercontent.com/raw/swaywm/sway/pull/5090.diff";
            sha256 = "sha256-m6g+mZCQSrebwXdBgUPIatdt8nLlfmOpbqCvJ4BML4w=";
          })
        ];
    }))
    .override {
      wayland = wayland-sway;
      wlroots = wlroots-sway;
    };

  wayland-sway = pkgs.wayland.overrideAttrs (_: rec {
    version = "1.21.0";

    src = pkgs.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wayland";
      repo = "wayland";
      rev = version;
      sha256 = "sha256-nvNDONDdpoYNDD5q29IisvUY2lHsEcgJYGJUWbhpijs=";
    };

    patches = [
      (pkgs.substituteAll {
        src = pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/primeos/nixpkgs/257a8075681b514e4e4821509672de34bd5267f7/pkgs/development/libraries/wayland/add-placeholder-for-nm.patch";
          sha256 = "sha256-L23c12q6x5ttqk4IA6b6thU4JHmJ7sOJ5rUauAtfOKU=";
        };
        nm = "${pkgs.stdenv.cc.targetPrefix}nm";
      })
    ];
  });

  wlroots-sway =
    (pkgs.wlroots.overrideAttrs (_: {
      src = pkgs.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "wlroots";
        repo = "wlroots";
        rev = "add44b3e2e4ff7ef98b16813fb3c9e1d8b398008";
        sha256 = "sha256-/fJGHeDuZ9aLjCSxILqNSm2aMrvlLZMZpx/WzX5A/XU=";
      };

      patches = [
        (pkgs.fetchpatch {
          url = "https://aur.archlinux.org/cgit/aur.git/plain/0001-xwayland-add-support-for-global-scale-factor.patch?h=wlroots-hidpi-git";
          sha256 = "sha256-sSG3ParCsJxIH7tF+4wt715lrAmBC4iVLJUB+icfDes=";
        })
        (pkgs.fetchpatch {
          url = "https://aur.archlinux.org/cgit/aur.git/plain/0002-xwayland-add-support-for-changing-global-scale-facto.patch?h=wlroots-hidpi-git";
          sha256 = "sha256-59S9Wu2yxUe3RzgFzykSvH1K+858CWn+MvUW6892Vyc=";
        })
      ];
    }))
    .override {wayland = wayland-sway;};

  xwayland = pkgs.xwayland.overrideAttrs (_: {
    patches = [
      ./patches/xwayland-vsync.patch
      (pkgs.fetchpatch {
        url = "https://aur.archlinux.org/cgit/aur.git/plain/xwlScaling.diff?h=xorg-xwayland-hidpi-git";
        sha256 = "sha256-xj/iw7zvWz9XMF6Q4rIY9IAQkXRClwdWyek4DwEmfFI=";
      })
    ];
  });
in
  sway-hidpi
