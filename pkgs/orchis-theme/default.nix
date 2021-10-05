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
  version = "unstable-2021-10-02";

  src = fetchFromGitHub {
    repo = "Orchis-theme";
    owner = "vinceliuice";
    rev = "cf8781e74d6c913511a4b2f9b81857e2296a51d5";
    sha256 = "sha256-ZH69B+t2fz1M0e1cDjLkvYdE3LdBEbPegTEMpZCJS0A=";
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
