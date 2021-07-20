{ lib
, legendary-gl
, writeShellScriptBin
, winetricks
, makeDesktopItem
, symlinkJoin
, wine
, winestreamproxy
, wineFlags ? ""
, pname ? "rocket-league"
, verbose ? false
, basepath ? "$HOME/Games"
, location ? "${basepath}/rocketleague"
, tricks ? [ "dxvk" "win10" ]
}:

# simple script to run Rocket League installed through legendary-gl

let
  rlicon = builtins.fetchurl {
    url = "https://www.pngkey.com/png/full/16-160666_rocket-league-png.png";
    name = "rocket-league.png";
    sha256 = "09n90zvv8i8bk3b620b6qzhj37jsrhmxxf7wqlsgkifs4k2q8qpf";
  };

  # concat winetricks args
  tricksString = with builtins;
    if (length tricks) > 0 then
      concatStringsSep " " tricks
    else
      "-V";

  script = writeShellScriptBin pname ''
    export WINEPREFIX="${location}"
    export DXVK_HUD=compiler
    export WINEFSYNC=1
    export WINEESYNC=1

    PATH=${wine}/bin:${winetricks}/bin:${legendary-gl}/bin:${winestreamproxy}/bin:$PATH

    if [ ! -d "$WINEPREFIX" ]; then
      # install tricks
      winetricks -q ${tricksString}
      wineserver -k
    fi

    legendary update Sugar --base-path ${basepath}
    # no rpc for rocket unless bakkesmod I guess
    #winestreamproxy -f &
    legendary launch Sugar --base-path ${basepath}
    wineserver -w
  '';

  desktopItems = makeDesktopItem {
    name = pname;
    desktopName = "Rocket League";
    genericName = "Rocket League";
    exec = "${script}/bin/${pname}";
    categories = "Game;";
    icon = rlicon;
  };
in
symlinkJoin {
  name = pname;
  paths = [ script desktopItems ];
  meta = {
    description = "Rocket League installer and runner (using legendary)";
    homepage = "https://rocketleague.com";
    license.free = false;
    maintainer = lib.maintainers.fufexan;
    platforms = with lib.platforms; [ "x86_64-linux" ];
  };
}
