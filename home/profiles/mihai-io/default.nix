{ config, pkgs, ... }:

{
  services.polybar.config = {
    "bar/external" = {
      "monitor" = "DisplayPort-1";
      "inherit" = "layout";
    };

    "module/wireless-network" = {
      interface = "wlp1s0";
    };
  };

  xsession.windowManager.bspwm.monitors = {
    eDP = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
    DisplayPort-1 = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
    DisplayPort-2 = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
  };
}
