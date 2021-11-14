{ config, ... }:

{
  services.xserver = {
    desktopManager.plasma5 = {
      enable = true;
      supportDDC = true;
      #useQtScaling = true;
      runUsingSystemd = true;
    };
  };
}
