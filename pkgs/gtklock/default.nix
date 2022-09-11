{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs,
  pam,
  scdoc,
  gtk3,
  pkg-config,
  gtk-layer-shell,
  wayland,
}:
stdenv.mkDerivation rec {
  pname = "gtklock";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "jovanlanik";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-G2PGvtQeAj/VNDxI2YZs0poXfm8KE320oSbyjpmwLsU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    scdoc
    wayland
  ];

  buildInputs = [
    gtk3
    gtk-layer-shell
    pam
  ];

  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  meta = with lib; {
    description = "GTK-based lockscreen for Wayland";
    longDescription = ''
      Important note: for gtklock to work you need to set "security.pam.services.gtklock = {};" manually.
    ''; # Following  nixpkgs/pkgs/applications/window-managers/sway/lock.nix
    homepage = "https://github.com/jovanlanik/gtklock";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [fufexan];
  };
}
