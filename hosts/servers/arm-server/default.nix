# biggest homeserver
{
  lib,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./minecraft.nix
    ./synapse.nix
  ];

  age.secrets.synapse-registration-shared-secret = {
    file = "${inputs.self}/secrets/synapse-registration-shared-secret.age";
    owner = "matrix-synapse";
    group = "matrix-synapse";
  };

  # used by tailscale for exit node
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };

  hardware.enableRedistributableFirmware = true;

  hardware.opengl.enable = lib.mkForce false;

  networking.hostName = "arm-server";
  networking.firewall.allowedTCPPorts = [25575];
  networking.firewall.allowedUDPPorts = [25575];

  system.stateVersion = lib.mkForce "21.11";

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMRDsoSresP7/VnrQOYsWWO/5V+EdPEx5PwI0DxW9H00 root@io"
  ];
  users.users.mihai.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEYe25Lbgm8IuhOLO5fPSVtJK+avw48yIq/rE1bOb7dl mihai@io"
  ];
}
