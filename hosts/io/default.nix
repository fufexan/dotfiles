# symbolistic yellow; main pc
{ config, lib, pkgs, ... }:

{
  #imports = [ ./hardware-configuration.nix ];

  # kernel
  boot.kernelPackages = pkgs.linuxPackages_xanmod;

  # bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  boot.plymouth.enable = true;

  hardware = {
    bluetooth = {
      enable = true;
      disabledPlugins = [ "sap" ];
      package = pkgs.bluezFull;
      powerOnBoot = false;
    };

    cpu.amd.updateMicrocode = true;

    enableAllFirmware = true;
  };

  networking.hostName = "io";

  programs = {
    adb.enable = true;
    steam.enable = true;
  };

  services = {
    pipewire.lowLatency.enable = true;

    printing.enable = true;

    ratbagd.enable = true;

    udev.extraRules = ''
      # add my android device to adbusers
      SUBSYSTEM=="usb", ATTR{idVendor}=="22d9", MODE="0666", GROUP="adbusers"
    '';

    xserver.videoDrivers = [ "amdgpu" ];

    zerotierone = {
      enable = true;
      joinNetworks = [ "af415e486f732fbc" ];
    };
  };
}
