# biggest homeserver
{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./services.nix
  ];

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

    enableAllFirmware = true;
  };

  networking.hostName = "kiiro";

  services = {
    btrfs.autoScrub.enable = true;

    journald.extraConfig = lib.mkForce "";
  };

  system.stateVersion = lib.mkForce "21.11";
}
