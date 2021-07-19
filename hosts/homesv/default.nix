# home server configuration
{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  age.secrets = {
    vaultwarden.file = ../../secrets/vaultwarden.age;
    ddclientConfig.file = ../../secrets/ddclientConfig.age;
    mailPass.file = ../../secrets/mailPass.age;
  };

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  # network
  networking = {
    hostName = "homesv";
    interfaces.enp9s0.useDHCP = true;
  };

  services = {
    # don't suspend when lid is closed
    logind.lidSwitch = "ignore";

    # keep journal
    journald.extraConfig = lib.mkForce "";
  };

  users.users = {
    user.isNormalUser = true;
    server = {
      isSystemUser = true;
      group = "server";
      extraGroups = [ "render" ];
    };
  };

  system.stateVersion = lib.mkForce "21.05";
}
