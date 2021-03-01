{ config, pkgs, ... }:

{
  # mouse configuration (usually gaming ones)
  services.ratbagd.enable = true;

  # torrent daemon
  services.transmission = {
    enable = true;
    group = "users";
    user = "mihai";
    home = "/home/mihai";
  };
  services.openssh = {
    enable = true;
    useDns = true;
  };

  # enable mDNS
  services.avahi = {
    enable = true;
    nssmdns = true;
    publish.enable = true;
    publish.domain = true;
  };

  # enable location services
  services.geoclue2.enable = true;

  services.printing = {
    enable = true;
    drivers = [ pkgs.fxlinuxprint ];
  };

  # samba public share
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = mihai
      netbios name = mihai
      hosts allow = 10.0.0.0/24 192.168.122.0/24 localhost
      hosts deny = 0.0.0.0/0
      use sendfile = yes
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      public = {
        path = "/home/mihai/Public";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0755";
      };
    };
  };

  # allow Windows clients to see samba
  services.samba-wsdd.enable = true;

  # Tailscale VPN alternative
  services.tailscale.enable = true;
}
