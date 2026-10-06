{
  config,
  pkgs,
  lib,
  self,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./hyprland.nix
  ];

  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

  networking.hostName = "ganymede";

  security.tpm2.enable = true;

  # for SSD/NVME
  services.fstrim.enable = true;

  users.users =
    let
      ids = import "${self}/secrets/identities.nix";
    in
    {
      root.openssh.authorizedKeys.keys = [ ids.io ];
      mihai.openssh.authorizedKeys.keys = [ ids.mihai-io ];
    };
}
