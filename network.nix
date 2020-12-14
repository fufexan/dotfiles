{ configs, pkgs, ... }:

{
  # enable DHCP
  networking = {
    useDHCP = false;
    interfaces.enp3s0.useDHCP = true;
  };

  # enable mDNS scanning
  services.avahi = {
    enable = true;
    nssmdns = true;
    publish.enable = true;
    publish.domain = true;
  };
}
