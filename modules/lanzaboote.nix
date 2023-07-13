{
  pkgs,
  lib,
  ...
}:
# lanzaboote config
{
  boot = {
    bootspec.enable = true;
    initrd = {
      systemd.enable = true;
      supportedFilesystems = ["ext4"];
    };
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    loader = {
      # systemd-boot on UEFI
      efi.canTouchEfiVariables = true;
      # we let lanzaboote install systemd-boot
      systemd-boot.enable = lib.mkForce false;
    };
  };

  environment.systemPackages = [pkgs.sbctl];
}
