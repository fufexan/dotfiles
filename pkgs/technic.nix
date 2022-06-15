{
  lib,
  makeDesktopItem,
  symlinkJoin,
  writeShellScriptBin,
  jdk,
  steam-run,
  withSteamRun ? true,
  pname ? "technic-launcher",
  source ?
    builtins.fetchurl rec {
      name = "technic-${lib.strings.sanitizeDerivationName sha256}";
      url = "https://launcher.technicpack.net/launcher4/680/TechnicLauncher.jar";
      sha256 = "sha256-NyWHCvz1CrCET8DZ40Y7qXZZTSBuL1bpoou/1Rc05Eg=";
    },
}: let
  version = "680";

  desktopItems = makeDesktopItem {
    name = pname;
    exec = pname;
    inherit icon;
    comment = "Technic Platform Launcher";
    desktopName = "Technic Launcher";
    categories = ["Game"];
  };

  icon = builtins.fetchurl {
    url = "https://worldvectorlogo.com/download/technic-launcher.svg";
    sha256 = "sha256-hZpqxNGCPWDGw1v2y1vMnvo6qGfqI9AfcmU+Q2u/KBc=";
  };

  script = writeShellScriptBin pname ''
    ${
      if withSteamRun
      then steam-run + "/bin/steam-run"
      else ""
    } ${jdk}/bin/java -jar ${source}
  '';
in
  symlinkJoin {
    name = "${pname}-${version}";
    paths = [desktopItems script];

    meta = {
      description = "Minecraft Launcher with support for Technic Modpacks";
      homepage = "https://technicpack.net";
      maintainers = [lib.maintainers.fufexan];
      platforms = lib.platforms.linux;
    };
  }
