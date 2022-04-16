# home server configuration
{ lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./services.nix
  ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  # used by tailscale for exit node
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };

  networking.hostName = "homesv";

  # don't suspend when lid is closed
  services.logind.lidSwitch = "ignore";

  system.stateVersion = lib.mkForce "21.05";

  users.users.user = {
    isNormalUser = true;
    createHome = false;
    hashedPassword = "$6$ENNQ3EC40RMVUr71$oIU8lKa072ucswxNID9CAL5r2v2ih3YK7Dfuva.lEgS22aOs/0Omcead2loZKnolMKqxaPushmV1XQhYtDzgV.";
  };
}
