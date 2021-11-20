{ config, pkgs, ... }:

{
  services.polybar.config = {
    "bar/external" = {
      "monitor" = "DVI-D-0";
      "inherit" = "layout";
    };

    "module/wireless-network" = {
      interface = "";
      "base-temperature" = 30;
      "warn-temperature" = 70;
    };

    "module/temperature".thermal-zone = "2";
  };

  xsession.windowManager.bspwm.monitors = {
    HDMI-0 = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
    VGA-0 = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
  };
}
