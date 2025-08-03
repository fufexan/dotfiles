# networking configuration
{pkgs, ...}: {
  networking = {
    # use quad9 with DNS over TLS
    nameservers = ["9.9.9.9#dns.quad9.net"];

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi.powersave = true;
      plugins = [
        pkgs.networkmanager-openvpn
      ];
    };
  };

  programs.ssh.extraConfig = ''
    Host neushore
      User builder
      HostName build.neushore.dev
      IdentityFile /home/mihai/.ssh/id_ed25519
      Port 30
  '';

  services = {
    openssh = {
      enable = true;
      settings.UseDns = true;
    };

    # DNS resolver
    resolved = {
      enable = true;
      dnsovertls = "opportunistic";
    };
  };

  systemd.services.NetworkManager-wait-online.serviceConfig.ExecStart = [
    ""
    "${pkgs.networkmanager}/bin/nm-online -q"
  ];
}
