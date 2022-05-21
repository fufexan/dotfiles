{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  gnome-themes-extra,
  gtk-engine-murrine,
  sassc,
  which,
  color ? "orange",
  tweaks ? [], # can be "nord" "black" "rimless". cannot mix "nord" and "black"
  size ? "compact", # can be "standard" "compact"
}: let
  validSizes = ["standard" "compact" ""];
  validColors = ["default" "purple" "pink" "red" "orange" "yellow" "green" "teal"];
  validTweaks = ["nord" "black" "rimless"];

  unknownTweaks = lib.subtractLists validTweaks tweaks;
  illegalMix = !(lib.elem "nord" tweaks) && !(lib.elem "black" tweaks);

  assertColor = lib.assertMsg (lib.elem color validColors) ''
    You entered wrong color: ${color}
    Valid colors are: ${toString validColors}
  '';

  assertIllegal = lib.assertMsg illegalMix ''
    Tweaks "nord" and "black" cannot be mixed. Tweaks: ${toString tweaks}
  '';

  assertSize = lib.assertMsg (lib.elem size validSizes) ''
    You entered wrong size: ${size}
    Valid sizes are: ${toString validSizes}
  '';

  assertUnknown = lib.assertMsg (unknownTweaks == []) ''
    You entered wrong tweaks: ${toString unknownTweaks}
    Valid tweaks are: ${toString validTweaks}
  '';
in
  assert assertColor;
  assert assertIllegal;
  assert assertSize;
  assert assertUnknown;
    stdenvNoCC.mkDerivation rec {
      pname = "catppuccin-gtk";
      version = "0.1.4";

      src = fetchFromGitHub {
        repo = "gtk";
        owner = "catppuccin";
        rev = "update_23_02_2022";
        sha256 = "sha256-AVhFw1XTnkU0hoM+UyjT7ZevLkePybBATJUMLqRytpk=";
      };

      nativeBuildInputs = [gtk3 sassc which];

      buildInputs = [gnome-themes-extra];

      propagatedUserEnvPkgs = [gtk-engine-murrine];

      patchPhase = ''
        runHook prePatch

        patchShebangs --build scripts/*
        substituteInPlace Makefile \
          --replace '$(shell git rev-parse --show-toplevel)' "$PWD"
        substituteInPlace 'scripts/install.sh' \
          --replace '$(git rev-parse --show-toplevel)' "$PWD"

        runHook postPatch
      '';

      preInstall = ''
        mkdir -p $out/share/themes
      '';

      installPhase = ''
        runHook preInstall

        bash scripts/install.sh -d $out/share/themes -t ${color} \
          ${lib.optionalString (size != "") "-s ${size}"} \
          ${lib.optionalString (tweaks != []) "--tweaks " + builtins.toString tweaks}

        runHook postInstall
      '';

      meta = with lib; {
        description = "Soothing pastel theme for GTK3";
        homepage = "https://github.com/catppuccin/gtk";
        license = licenses.gpl3Plus;
        platforms = platforms.linux;
        maintainers = [maintainers.fufexan];
      };
    }
