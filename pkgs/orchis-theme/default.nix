{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, gnome-themes-extra
, gtk-engine-murrine
, sassc
, accentColor ? "default"
, tweaks ? "" # can be "solid" "compact" "black" "primary", or concatenated
}:

stdenvNoCC.mkDerivation rec {
  pname = "orchis-theme";
  version = "unstable-2021-08-30";

  src = fetchFromGitHub {
    repo = "Orchis-theme";
    owner = "vinceliuice";
    rev = "eb279b5446e14710add8fcdbec735f4f9ce1dc6f";
    sha256 = "sha256-ORHE0EGxejoyq093co/NxesboTsS4NcyhGx5AygMOzg=";
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
