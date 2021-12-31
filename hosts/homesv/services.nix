{ config, ... }:

# server services

{
  services.samba = {
    enable = true;
    nsswins = true;
    extraConfig = ''
      server smb encrypt = desired
      hosts deny = ALL
      hosts allow = 10. 100. localhost
      map to guest = Bad User
    '';
    shares.drive = {
      path = "/media";
      browseable = "yes";
      "read only" = "no";
      "create mask" = "0664";
      "directory mask" = "0755";
      "force group" = "users";
    };
    openFirewall = true;
  };

  services.samba-wsdd = {
    enable = true;
    discovery = true;
  };

  networking.firewall.allowedTCPPorts = [ 80 139 443 445 5357 8384 8443 ];
  networking.firewall.allowedUDPPorts = [ 137 138 3702 ];

  services.syncthing = {
    enable = true;
    group = "users";
    guiAddress = ":8384";
    openDefaultPorts = true;
  };

  services.transmission = {
    home = "/media/Torrents";
    openFirewall = true;
    openRPCPort = true;
    settings.rpc-bind-address = "0.0.0.0";
    settings.rpc-whitelist = "127.0.0.1,10.*,100.*";
    settings.rpc-host-whitelist = "homesv,homesv.local";
  };
}
