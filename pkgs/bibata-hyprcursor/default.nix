{
  lib,
  stdenvNoCC,
  fetchurl,
  bibata-cursors,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bibata-hyprcursor";

  inherit (bibata-cursors) version;

  src = fetchurl {
    url = "https://drive.usercontent.google.com/download?id=1HkJPuKNkf4zfVYbQ6IxHUl5KaDXgFest";
    name = "HyprBibataModernClassic.tar.gz";
    hash = "sha256-KDYoULjJC0Nhdx9Pz5Ezq+1F0tWwkVQIc5buy07hO98=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r $PWD $out/share/icons

    runHook postInstall
  '';

  meta = {
    description = "Open source, compact, and material designed cursor set";
    homepage = "https://github.com/LOSEARDES77/Bibata-Cursor-hyprcursor";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [fufexan];
  };
})
