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
        blur-me
        gsconnect
        night-theme-switcher
        vitals

        # paperwm
        paperwm
        disable-workspace-switch-animation-for-gnome-40
        cleaner-overview
        vertical-overview
      ] ++ [ pkgs.gnome.gnome-tweaks ];
    };
  };
}
