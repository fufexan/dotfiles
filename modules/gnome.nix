{
  lib,
  pkgs,
  ...
}:
# GNOME 41 config
{
  environment.systemPackages = with pkgs.gnomeExtensions; [
    appindicator
    gsconnect
    ideapad-mode
    vitals
    pkgs.gnome.gnome-tweaks
  ];

  # we're using pipewire instead
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

  services.gnome.games.enable = true;
  services.xserver = {
    desktopManager.gnome = {
      enable = true;
    };
  };
}
