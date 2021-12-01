{ lib, pkgs, ... }:

# GNOME 40 config

{
  hardware.pulseaudio.enable = lib.mkForce false;

  networking = {
    # for GSConnect
    firewall = {
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
    };
  };

  services.xserver = {
    desktopManager.gnome = {
      enable = true;
      sessionPath = with pkgs.gnomeExtensions; [
        appindicator
        gsconnect
        vitals
      ];
    };
  };
}
