{
  pkgs,
  lib,
  self,
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

  services = {
    # for SSD/NVME
    fstrim.enable = true;

    ddccontrol = {
      enable = true;
      package = pkgs.ddcutil-service;
    };
  };

  users.users.root.openssh.authorizedKeys.keys =
    let
      ids = import "${self}/secrets/identities.nix";
    in
    [ ids.io ];
}
