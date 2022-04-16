# biggest homeserver
{ lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.cleanTmpDir = true;

  # used by tailscale for exit node
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };

  hardware.enableAllFirmware = true;

  hardware.opengl.enable = lib.mkForce false;

  networking.hostName = "arm-server";

  system.stateVersion = lib.mkForce "21.11";

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIerY8yuoW7svJYuRbLa63nHCD7A4KIwa/rRHXGO5iY+w90RCUtRwVsnJxHkYXQcCSAC60PeOBp9Um2E0TtkNsDl3pvcLU4A1yEDlTemTmmXP86T4AVmsVcs6wPdiuEcCN1PRmgiN25NMyz0y4oyFho+Qboy0K2BNr9EkVBmtdWZfXQc/7p7f7y24xY9M1lDJCltGpmc2TBKfWZH6iKtRQPN+ZP474+b+tQw7Hbi+xC1q0uTVdlA0ZKyYZm2+e3ILPvr8M9m293mV1fqSiYRBujtvhWaKagiFMXA4VEd7GRqg6Mj6pKNS9J4KAgFmyc2Dham69EY/5P48VpmLiG6uD ssh-key-2022-03-31"
  ];
  users.users.mihai.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIerY8yuoW7svJYuRbLa63nHCD7A4KIwa/rRHXGO5iY+w90RCUtRwVsnJxHkYXQcCSAC60PeOBp9Um2E0TtkNsDl3pvcLU4A1yEDlTemTmmXP86T4AVmsVcs6wPdiuEcCN1PRmgiN25NMyz0y4oyFho+Qboy0K2BNr9EkVBmtdWZfXQc/7p7f7y24xY9M1lDJCltGpmc2TBKfWZH6iKtRQPN+ZP474+b+tQw7Hbi+xC1q0uTVdlA0ZKyYZm2+e3ILPvr8M9m293mV1fqSiYRBujtvhWaKagiFMXA4VEd7GRqg6Mj6pKNS9J4KAgFmyc2Dham69EY/5P48VpmLiG6uD ssh-key-2022-03-31"
  ];
}
