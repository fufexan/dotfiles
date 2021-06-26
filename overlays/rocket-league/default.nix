{ lib
, legendary-gl
, writeShellScriptBin
, winetricks
, makeDesktopIcon
, symlinkJoin
, wine ? null
, wineFlags ? ""
, pname ? "rocket-league"
, verbose ? false
, location ? "$HOME/Games/rocketleague"
, tricks ? [ dxvk ]
, dib
}:

# simple script to run Rocket League installed through legendary-gl

let
  rlicon = builtins.fetchurl {
    url = "";
    name = "rl.png";
    sha256 = lib.fakeSha256;
  };

  # discord ipc bridge stuff
  REGKEY = "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\RunServices";
  wdib = "winediscordipcbridge.exe";

  # concat winetricks args
  tricks = with builtins;
    if (length tricks) > 0 then
      concatStringsSep " " tricks
    else
      "-V";

  script = writeShellScriptBin pname ''
    export WINEPREFIX="${location}"

    PATH=${wine}/bin:${winetricks}/bin:${legendary-gl}/bin:$PATH

    if [ ! -d "$WINEPREFIX" ]; then
      # install tricks
      winetricks -q -f ${tricksStmt}
      wineserver -k

      # install Rocket League
      legendary install Sugar --base-path $HOME/Games/${pname}

      # install ipcbridge
      cp ${dib}/bin/${wdib} $WINEPREFIX/drive_c/windows/${wdib}
      wine reg add '${REGKEY}' /v winediscordipcbridge /d 'C:\windows\${wdib}' /f

    fi

    legendary launch Sugar
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
}
