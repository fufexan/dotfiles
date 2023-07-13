# biggest homeserver
{lib, ...}: {
  imports = [./hardware-configuration.nix];

  # used by tailscale for exit node
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  hardware = {
    cpu.intel.updateMicrocode = true;

    enableRedistributableFirmware = true;
  };

  networking.hostName = "kiiro";

  services.btrfs.autoScrub.enable = true;

  system.stateVersion = lib.mkForce "21.11";
}
