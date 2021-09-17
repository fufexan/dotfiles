{ config, pkgs, ... }:

# my own installer

{
  # kernel
  boot.kernelPackages = pkgs.linuxPackages_xanmod;
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
  };
}
