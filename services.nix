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

  # enable printing
  services.printing = {
    enable = true;
    drivers = [ pkgs.fxlinuxprint ];
  };

  # usb stick automount, cifs browsing, etc
  services.gvfs.enable = true;

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

  # enable phone-computer integration
  systemd.user.services.kdeconnect = {
    enable = true;
    wantedBy = [
      "multi-user.target"
      "graphical-session.target"
    ];
    description = "KDEConnect daemon";
    script = "${pkgs.kdeconnect}/bin/kdeconnect-indicator";
    serviceConfig = {
      Restart = "always";
      StandardOutput = "syslog";
    };
  };
}
