# home server configuration
{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./mailserver.nix
    ./services.nix
  ];

  age.secrets = {
    ddclientConfig.file = ../../secrets/ddclientConfig.age;
    mailPass.file = ../../secrets/mailPass.age;
    vaultwarden.file = ../../secrets/vaultwarden.age;
  };

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  # network
  networking.hostName = "homesv";

  services = {
    # don't suspend when lid is closed
    logind.lidSwitch = "ignore";

    # keep journal
    journald.extraConfig = lib.mkForce "";
  };

  users.users = {
    user.isSystemUser = true;
  };

  system.stateVersion = lib.mkForce "21.05";
}
