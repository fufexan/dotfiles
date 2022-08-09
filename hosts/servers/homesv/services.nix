# server services
{
  services.samba = {
    enable = true;
    nsswins = true;
    extraConfig = ''
      hosts allow = 10.0.0.0/8 100.0.0.0/8 localhost
      hosts deny = 0.0.0.0/8
      guest account = nobody
      map to guest = bad user
    '';
    shares.drive = {
      path = "/media";
      browseable = "yes";
      "read only" = "no";
      "guest ok" = "yes";
      "create mask" = "0777";
      "directory mask" = "0777";
    };
    openFirewall = true;
  };

  services.samba-wsdd = {
    enable = true;
    discovery = true;
  };

  networking.firewall.allowedTCPPorts = [80 139 443 445 5357 8384 8443];
  networking.firewall.allowedUDPPorts = [137 138 3702];

  services.syncthing = {
    enable = true;
    group = "users";
    guiAddress = ":8384";
    openDefaultPorts = true;
  };

  services.transmission = {
    enable = true;
    user = "nobody";
    home = "/media/Torrents";
    openFirewall = true;
    openRPCPort = true;
    settings.rpc-bind-address = "0.0.0.0";
    settings.rpc-whitelist = "127.0.0.1,10.*,100.*";
    settings.rpc-host-whitelist = "homesv,homesv.local";
  };
}
