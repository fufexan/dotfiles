{ config, pkgs, ... }:

{
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

    #"module/temperature".thermal-zone = "2";
  };
}
