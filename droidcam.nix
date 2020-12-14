{ pkgs, configs, ... }:

# since online school took place and I don't have a (builtin) camera, I use
# droidcam
{
  # add NUR to nixpkgs
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  # install droidcam and its module
  environment.systemPackages = with pkgs; [
    nur.repos.suhr.droidcam
    nur.repos.suhr.v4l2loopback-dc
  ];

  # make module available to modprobe
  boot.extraModulePackages = [ pkgs.nur.repos.suhr.v4l2loopback-dc ];

  # load needed module at boot
  boot.kernelModules = [ "v4l2loopback-dc" ];
}
