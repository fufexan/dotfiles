{
  lib,
  fetchzip,
  makeDesktopItem,
  symlinkJoin,
  writeShellScriptBin,
  jdk,
  steam-run,
  withSteamRun ? true,
  pname ? "tlauncher",
  source ?
    fetchzip rec {
      name = "tlauncher-${lib.strings.sanitizeDerivationName sha256}";
      url = "https://tlauncher.org/jar";
      sha256 = "sha256-Tpia/GtPfeO8/Tca0fE7z387FRpkXfS1CtvX/oNJDag=";
      stripRoot = false;
      extension = "zip";
    },
}: let
  version = "2.86";

  desktopItems = makeDesktopItem {
    name = pname;
    exec = pname;
    inherit icon;
    comment = "TLauncher";
    desktopName = "TLauncher";
    categories = ["Game"];
  };

  icon = builtins.fetchurl {
    url = "https://tlauncher.org/fav-icon-512.png";
    sha256 = "1g3fwp5pxvb22xcsw226czyr3xicxxwpgl69lyii949rzr2x8bw5";
  };

  script = writeShellScriptBin pname ''
    ${
      if withSteamRun
      then steam-run + "/bin/steam-run"
      else ""
    } ${jdk}/bin/java -jar ${source}/TLauncher-${version}.jar
  '';
in
  symlinkJoin {
    name = "${pname}-${version}";
    paths = [desktopItems script];

    meta = {
      description = "Minecraft Launcher";
      homepage = "https://tlauncher.org/en";
      maintainers = [lib.maintainers.fufexan];
      platforms = lib.platforms.linux;
    };
  }
