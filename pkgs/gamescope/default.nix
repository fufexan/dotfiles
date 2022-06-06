{
  stdenv,
  fetchFromGitHub,
  meson,
  pkg-config,
  cmake,
  ninja,
  xorg,
  libdrm,
  vulkan-loader,
  wayland,
  wayland-protocols,
  libxkbcommon,
  libcap,
  SDL2,
  pipewire,
  mesa,
  udev,
  pixman,
  libinput,
  libseat,
  xwayland,
  glslang,
  stb,
  wlroots,
  libliftoff,
}: let
in
  stdenv.mkDerivation {
    pname = "gamescope";
    version = "3.11.28-beta4";
    src = fetchFromGitHub {
      owner = "Plagman";
      repo = "gamescope";
      rev = "refs/tags/3.11.28-beta4";
      hash = "sha256-3L3bQIPPfScvtN1dduh10dQu/AuTmD4dHNp3JjBIBLA=";
    };

    buildInputs = [
      xorg.libX11
      xorg.libXdamage
      xorg.libXcomposite
      xorg.libXrender
      xorg.libXext
      xorg.libXxf86vm
      xorg.libXtst
      xorg.libXres
      libdrm
      vulkan-loader
      wayland
      wayland-protocols
      libxkbcommon
      libcap
      SDL2
      pipewire
      mesa
      udev
      pixman
      libinput
      libseat
      xwayland
      xorg.xcbutilwm
      xorg.xcbutilerrors
      glslang
      xorg.libXi
    ];

    prePatch = ''
      echo ":: Copying stb"
      cp -vr "${stb.src}" subprojects/stb
      chmod -R +w subprojects/stb
      cp "subprojects/packagefiles/stb/meson.build" "subprojects/stb/"

      echo ":: Copying wlroots"
      rmdir subprojects/wlroots
      cp -vr "${wlroots.src}" subprojects/wlroots
      chmod -R +w subprojects/wlroots

      echo ":: Copying libliftoff"
      rmdir subprojects/libliftoff
      cp -vr "${libliftoff.src}" subprojects/libliftoff
      chmod -R +w subprojects/libliftoff
    '';

    nativeBuildInputs = [
      cmake
      meson
      pkg-config
      ninja
    ];

    dontUseCmakeConfigure = true;
  }
