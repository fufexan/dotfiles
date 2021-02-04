{ pkgs, configs, ... }:

{
  # configuration of gaming mice
  services.ratbagd.enable = true;

  # file sync, transfer and secure shell
  services.syncthing = {
    enable = true;
    user = "mihai";
    dataDir = "/home/mihai/Sync";
    configDir = "/home/mihai/.config/syncthing";
  };
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

  services.printing = {
    enable = true;
    drivers = [ pkgs.fxlinuxprint ];
  };

  # usb stick automount, cifs browsing, etc
  services.gvfs.enable = true;

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

  # to be used on 21.03
  #services.samba-wsdd.enable = true;

  # user services

  # enable IBus on graphical session startup
  systemd.user.services.ibus-daemon = {
    enable = true;
    wantedBy = [
      "multi-user.target"
      "graphical-session.target"
    ];
    description = "IBus daemon";
    script = "${pkgs.ibus-with-plugins}/bin/ibus-daemon";
    serviceConfig = {
      Restart = "always";
      StandardOutput = "syslog";
    };
  };
}
