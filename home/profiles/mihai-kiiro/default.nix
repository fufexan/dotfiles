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
}
