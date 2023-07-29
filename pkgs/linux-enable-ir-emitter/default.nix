{
  stdenv,
  lib,
  makeWrapper,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  python3,
  opencv,
  usbutils,
}:
stdenv.mkDerivation rec {
  pname = "linux-enable-ir-emitter";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "EmixamPP";
    repo = pname;
    rev = version;
    hash = "sha256-Dv1ukn2TkXfBk1vc+6Uq7tw8WwCAfIcKl13BoOifz+Q=";
  };

  nativeBuildInputs = [meson ninja pkg-config makeWrapper];
  buildInputs = [python3 opencv];

  patches = [./remove-boot-set.patch];

  postInstall = ''
    wrapProgram $out/bin/${pname} --prefix PATH : ${lib.makeBinPath [usbutils]}
  '';
}
