{ config, pkgs, ... }:

{
  # kernel to use
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # modules to load
  boot.kernelModules = [ "v4l2loopback" ];

  # make modules available to modprobe
  boot.extraModulePackages = [ pkgs.linuxPackages_zen.v4l2loopback ];

  # browser fix on Intel CPUs
  boot.kernelParams = [ "intel_pstate=active" ];
}
