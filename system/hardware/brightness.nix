{ pkgs, lib, ... }:
let
  idle-brightness = pkgs.writeShellScriptBin "idle-brightness" ''
    B="${lib.getExe pkgs.brillo}"
    DIRECTION="''${1-"low"}"
    DEVICES="$($B -L)"
    ARGS=""

    if [[ "$DEVICES" != *"ddcci"* ]]; then
      [ "$DIRECTION" = "high" ] && ARGS="-u 250000" || ARGS="-u 500000"
    fi

    if [ "$DIRECTION" = "high" ]; then
      $B -I $ARGS
    else
      $B -O; $B $ARGS -S 10
    fi
  '';

  bright = pkgs.writeShellScriptBin "bright" ''
    B="${lib.getExe pkgs.brillo}"

    DEVICES="$($B -L)"
    ARGS=""

    if [[ "$DEVICES" != *"ddcci"* ]]; then
      ARGS="-u 300000"
    fi

    $B $ARGS $@
  '';
in
{
  environment.systemPackages = [
    bright
    idle-brightness
  ];
}
