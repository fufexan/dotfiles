{ lib, pkgs, ... }:

# GNOME 41 config

{
  environment.systemPackages = with pkgs.gnomeExtensions; [
    appindicator
    gsconnect
    vitals
    pkgs.pantheon.elementary-sound-theme
  ];

  # we're using pipewire instead
  hardware.pulseaudio.enable = lib.mkForce false;

  networking = {
    # for GSConnect
    firewall = {
      allowedTCPPortRanges = [{
        from = 1714;
        to = 1764;
      }];
      allowedUDPPortRanges = [{
        from = 1714;
        to = 1764;
      }];
    };
  };

  services.xserver = {
    desktopManager.gnome = {
      enable = true;
    };
  };

  # currently broken. TODO: fix
  #nixpkgs.overlays = [
  #  (final: prev: {
  #    gnome.gdm = prev.gnome.gdm.overrideAttrs (o: { patches = o.patches ++ [ ../pkgs/patches/gdm.patch ]; });
  #  })
  #];
}
