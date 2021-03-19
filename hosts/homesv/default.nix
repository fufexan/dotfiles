# home server configuration
{ config, pkgs, agenix, inputs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  age.secrets.homesv.file = ../../secrets/homesv.age;

  home-manager.users.mihai = import ../../home/minimal.nix;

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  environment.systemPackages = [ inputs.agenix.defaultPackage.x86_64-linux ]; 

  # network
  networking = {
    hostName = "homesv";
    interfaces.enp3s0.useDHCP = true;
    interfaces.wlp2s0.useDHCP = true;
    wireless.iwd.enable = true;
  };
  networking.firewall.enable = false;

  users.users = {
    user.isNormalUser = true;
    server = {
      isSystemUser = true;
      group = "server";
      extraGroups = [ "render" ];
    };
  };
}
