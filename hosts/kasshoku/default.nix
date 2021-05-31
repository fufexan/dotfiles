# home server configuration
{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  environment.systemPackages = lib.mkForce [ pkgs.git ];

  hardware.opengl.driSupport32Bit = lib.mkForce false;

  # network
  networking = {
    hostName = "kasshoku";
    interfaces.enp9s0.useDHCP = true;
    wireless.iwd.enable = true;
    enableB43Firmware = true;
  };

  system.stateVersion = lib.mkForce "21.05";
}
