{
  lib,
  fetchurl,
  makeDesktopItem,
  symlinkJoin,
  writeShellScriptBin,
  jdk,
  steam-run,
  withSteamRun ? true,
  pname ? "TL",
  source ? null,
} @ args: let
  version = "2.86";

  src = fetchurl rec {
    name = "TL-${lib.strings.sanitizeDerivationName sha256}.jar";
    url = "https://tlaun.ch/jar";
    sha256 = "sha256-Uef9RAuPwMt6yo6cOg3878RzLH2UPUX/y+QO937FHNE=";
  };

  desktopItems = makeDesktopItem {
    name = pname;
    exec = pname;
    inherit icon;
    comment = "Minecraft Launcher";
    desktopName = "TL";
    categories = ["Game"];
  };

  icon = ./TL.svg;

  script = writeShellScriptBin pname ''
    ${
      if withSteamRun
      then steam-run + "/bin/steam-run"
      else ""
    } ${jdk}/bin/java -jar ${args.source or src}
  '';
in
  symlinkJoin {
    name = "${pname}-${version}";
    paths = [desktopItems script];

    meta = {
      description = "Minecraft Launcher";
      homepage = "https://tlaun.ch";
      maintainers = [lib.maintainers.fufexan];
      platforms = lib.platforms.linux;
    };
  }
