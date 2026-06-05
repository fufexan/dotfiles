{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./hyprland.nix
    ./powersave.nix
  ];

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;

  # nh default flake
  environment.variables.NH_FLAKE = "/home/mihai/Projects/dotfiles";

  networking.hostName = "ganymede";

  security.tpm2.enable = true;

  # for SSD/NVME
  services.fstrim.enable = true;
}
