# home server configuration
{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  hardware.opentabletdriver.enable = true;

  # network
  networking = {
    hostName = "tosh";
    networkmanager.enable = true;
  };
}
