{ config, pkgs, ... }:

let
  poly = pkgs.polybar.override {
    pulseSupport = true;
  };

  mprisScript = pkgs.callPackage ./mpris.nix { };
  mprisModule = ''
    [module/mpris]
    type = custom/script

    exec = ${mprisScript}/bin/mpris
    tail = true

    label-maxlen = 60

    interval = 2
    format =  <label>
    format-padding = 2
  '';
in
{
  services.polybar = {
    enable = true;
    package = poly;
    config = ./config.ini;
    extraConfig = mprisModule;
    script = ''
      polybar main &
    '';
  };
}
