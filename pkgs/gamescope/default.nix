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
}:
stdenv.mkDerivation rec {
  pname = "gamescope";
  version = "3.11.33-beta1";
  src = fetchFromGitHub {
    owner = "Plagman";
    repo = "gamescope";
    rev = version;
    hash = "sha256-KAvOmxYSwLA6/zOppDzgI7z8+XCMMEPol1vo/SDuRXE=";
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
