# stolen from https://github.com/diniamo/niqspkgs/blob/544c3b2c69fd1b5ab3407e7b35c76060801a8bcf/pkgs/bibata-hyprcursor/default.nix
{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  python3Packages,
  hyprcursor,
  variant ? "modern",
  baseColor ? "#000000",
  outlineColor ? "#FFFFFF",
  watchBackgroundColor ? "#000000",
  colorName ? "classic",
}: let
  capitalize = str: let
    capital_letter = builtins.substring 0 1 str;
    non_capital = lib.removePrefix capital_letter str;
  in
    lib.toUpper capital_letter + non_capital;

  themeName = "Bibata-${capitalize variant}-${capitalize colorName}";
in
  assert builtins.elem variant ["modern" "modern-right" "original" "original-right"];
    stdenvNoCC.mkDerivation (final: {
      pname = "bibata-hyprcursor";
      version = "v2.0.7";

      src = fetchFromGitHub {
        owner = "ful1e5";
        repo = "Bibata_Cursor";
        rev = final.version;
        hash = "sha256-kIKidw1vditpuxO1gVuZeUPdWBzkiksO/q2R/+DUdEc=";
      };

      nativeBuildInputs = [
        python3
        python3Packages.tomli
        python3Packages.tomli-w
        hyprcursor
      ];

      phases = ["unpackPhase" "configurePhase" "buildPhase" "installPhase"];

      unpackPhase = ''
        runHook preUnpack

        cp $src/configs/${
          if lib.hasSuffix "right" variant
          then "right"
          else "normal"
        }/x.build.toml config.toml

        mkdir cursors
        for cursor in $src/svg/${variant}/*; do
          cp -r $src/svg/${variant}/$(readlink $cursor) cursors
        done

        chmod -R u+w .

        runHook postUnpack
      '';

      configurePhase = ''
        runHook preConfigure

        cat << EOF > manifest.hl
        name = ${themeName}
        description = The Bibata Cursor theme packaged for hyprcursor.
        version = ${final.version}
        cursors_directory = cursors
        EOF

        find cursors -type f -name '*.svg' | xargs sed -i -e 's/#00FF00/${baseColor}/g' -e 's/#0000FF/${outlineColor}/g' -e 's/#FF0000/${watchBackgroundColor}/g'

        python ${./configure.py} config.toml cursors

        runHook postConfigure
      '';

      buildPhase = ''
        runHook preBuild
        hyprcursor-util --create . --output .
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out/share/icons
        cp -r theme_${themeName} $out/share/icons/${themeName}

        runHook postInstall
      '';
    })
