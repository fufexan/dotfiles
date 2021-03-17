{ pkgs, ... }:

{
  services.ratbagd.enable = true;

  services.transmission.enable = true;

  services.openssh = {
    enable = true;
    useDns = true;
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish.enable = true;
    publish.domain = true;
  };

  services.geoclue2.enable = true;

  services.printing = {
    enable = true;
    drivers = [ pkgs.fxlinuxprint ];
  };

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
  services.samba-wsdd.enable = true;

  services.tailscale.enable = true;

  services.udisks2.enable = true;
}
