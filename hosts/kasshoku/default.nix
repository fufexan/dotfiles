# home server configuration
{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  # network
  networking = {
    hostName = "kasshoku";
    interfaces.enp9s0.useDHCP = true;
  };

  system.stateVersion = lib.mkForce "21.05";
}
