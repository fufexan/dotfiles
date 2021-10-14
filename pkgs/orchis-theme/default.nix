{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, gnome-themes-extra
, gtk-engine-murrine
, sassc
, accentColor ? "all"
, tweaks ? "" # can be "solid" "compact" "black" "primary", or concatenated
}:

stdenvNoCC.mkDerivation rec {
  pname = "orchis-theme";
  version = "unstable-2021-10-13";

  src = fetchFromGitHub {
    repo = "Orchis-theme";
    owner = "vinceliuice";
    rev = "18811c46cc6178ce70adcc0bee56fe0cf9af19f4";
    sha256 = "sha256-B0YSpdoRfB8DvMx+3yXpNLEULnLd1BoqNWLXRPOfp2Q=";
  };

  nativeBuildInputs = [ gtk3 sassc ];

  buildInputs = [ gnome-themes-extra ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  preInstall = ''
    mkdir -p $out/share/themes
  '';

  installPhase = ''
    runHook preInstall
    bash install.sh -d $out/share/themes -t ${accentColor} ${if tweaks != "" then "--tweaks " + tweaks else ""}
    runHook postInstall
  '';

  meta = with lib; {
    description = "A Material Design theme for GNOME/GTK based desktop environments.";
    homepage = "https://github.com/vinceliuice/Orchis-theme";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.fufexan ];
  };
}
