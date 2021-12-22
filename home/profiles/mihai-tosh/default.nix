{ config, pkgs, ... }:

{
  imports = [
    ../.
    ../../x11
  ];

  services.polybar.config = {
    "bar/external" = {
      "monitor" = "VGA-1";
      "inherit" = "layout";
    };

    "module/wireless-network" = {
      interface = "wlp2s0";
      "base-temperature" = 30;
      "warn-temperature" = 70;
    };
  };

  xsession.windowManager.bspwm.monitors = {
    LVDS-1 = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
  };
}
