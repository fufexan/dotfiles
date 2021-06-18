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

    label-maxlen = 100

    interval = 2
    format = <label>
    format-padding = 2
  '';
  pulseModule = ''
    [module/pulseaudio]
    type = internal/pulseaudio
    sink = 
    use-ui-max = false
    interval = 5
    click-right = ${pkgs.pavucontrol}/bin/pavucontrol
    format-volume = <ramp-volume> <label-volume>
    label-muted = 󰸈 muted
    label-muted-foreground = #66

    ramp-volume-0 = 󰕿
    ramp-volume-1 = 󰖀
    ramp-volume-2 = 󰕾
  '';
in
{
  services.polybar = {
    enable = true;
    package = poly;
    config = ./config.ini;
    extraConfig = mprisModule + pulseModule;
    script = ''
      polybar main &
    '';
  };
}
