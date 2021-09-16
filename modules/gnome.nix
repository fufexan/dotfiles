{ lib, pkgs, ... }:

# GNOME 40 config

{
  environment.gnome.excludePackages = with pkgs.gnome; [
    gnome-contacts
    gnome-disk-utility
    gnome-font-viewer
    gnome-maps
    yelp
  ] ++ (
    with pkgs; [
      cheese
      epiphany
      geany
      gnome-connections
    ]
  );

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
        alttab-mod
        appindicator
        blur-me
        gsconnect
        paperwm
        vitals

        disable-workspace-switch-animation-for-gnome-40
        cleaner-overview
        vertical-overview
      ] ++ [ pkgs.gnome.gnome-tweaks ];
    };
  };
}
