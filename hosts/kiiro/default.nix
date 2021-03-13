# symbolistic yellow; main pc
{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # kernel
  boot.kernelPackages = pkgs.linuxPackages_lqx;
  # modules to load
  boot.kernelModules = [ "v4l2loopback" ];
  # make modules available to modprobe
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  # browser fix on Intel CPUs
  boot.kernelParams = [ "intel_pstate=active" ];

  # bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  # enable Nvidia KMS (for Wayland and less screen tearing on Xorg)
  hardware.nvidia.modesetting.enable = true;

  # Japanese input using fcitx
  i18n.inputMethod = {
    enabled = "fcitx";
    fcitx.engines = with pkgs.fcitx-engines; [ mozc ];
  };

  networking = {
    hostName = "kiiro";
    interfaces.enp3s0.useDHCP = true;
  };
  networking.firewall.enable = false;

  programs.adb.enable = true;
  programs.steam.enable = true;

  # use dconf in Home Manager
  services.dbus.packages = [ pkgs.gnome3.dconf ];

  virtualisation.libvirtd.enable = true;
  environment.systemPackages = with pkgs; [ virt-manager ];
}
