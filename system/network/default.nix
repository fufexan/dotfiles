# networking configuration
{ self, pkgs, ... }:
{
  networking = {
    # use quad9 with DNS over TLS
    nameservers = [ "9.9.9.9#dns.quad9.net" ];

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi.powersave = true;
      plugins = [
        pkgs.networkmanager-openvpn
      ];
    };
  };

  services = {
    openssh = {
      enable = true;
      settings.UseDns = true;
      knownHosts =
        let
          ids = import "${self}/secrets/identities.nix";
        in
        {
          io.publicKey = ids.io;
          ganymede.publicKey = ids.ganymede;
        };
    };

    # DNS resolver
    resolved = {
      enable = true;
      # Disable until https://github.com/NixOS/nixpkgs/issues/440073 is fixed
      # Waiting for https://github.com/NixOS/nixpkgs/pull/440130 to land in nixos-unstable
      # dnsovertls = "opportunistic";
    };
  };

  systemd.services.NetworkManager-wait-online.serviceConfig.ExecStart = [
    ""
    "${pkgs.networkmanager}/bin/nm-online -q"
  ];
}
