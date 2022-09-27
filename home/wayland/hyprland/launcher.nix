{
  pkgs,
  lib,
  ...
}: let
  launcher = "${lib.getExe pkgs.wofi} -f";
  pkillName = ".wofi-wrapped";
in
  pkgs.writeShellScript "launch-launcher" ''
    LOCK_FILE="$XDG_CACHE_HOME/launcher.lock"

    if [ ! -f "$LOCK_FILE" ]; then
      ${launcher}
      touch "$LOCK_FILE"
    else
      pkill ${pkillName}
      rm "$LOCK_FILE"
    fi
  ''
