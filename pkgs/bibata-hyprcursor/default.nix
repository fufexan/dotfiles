{
  lib,
  stdenvNoCC,
  bibata-cursors,
  hyprcursor,
  util-linux,
  xcur2png,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bibata-hyprcursor";

  inherit (bibata-cursors) src version;

  nativeBuildInputs = [
    hyprcursor
    util-linux
    xcur2png
  ];

  buildPhase = ''
    runHook preBuild

    cp -r ${bibata-cursors}/share/icons ./original
    mkdir -p extracted themes icons

    for theme in ./original/*; do
      theme="$(basename $theme)"

      cp -r "./original/$theme" "./icons/$theme-hyprcursor"

      theme="$theme-hyprcursor"

      hyprcursor-util --extract "icons/$theme" --output extracted

      rename extracted_ "" extracted/*

      echo -e "name = $theme\ndescription = $theme for Hyprcursor\nversion = ${finalAttrs.version}\ncursors_directory = hyprcursors" >"extracted/$theme/manifest.hl"

      hyprcursor-util --create "extracted/$theme" --output themes
    done

    rename theme_ "" themes/*

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r themes/* $out/share/icons

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
