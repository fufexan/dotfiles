{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # kernel
  boot.consoleLogLevel = 6;
  boot.kernelPackages = pkgs.linuxPackages_xanmod;
  boot.kernelParams = [ "iommu=soft" "nmi_watchdog=0" ];

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
      hsphfpd.enable = true;
      package = pkgs.bluezFull;
      powerOnBoot = false;
    };

    cpu.amd.updateMicrocode = true;

    enableAllFirmware = true;
  };

  networking.hostName = "io";

  nix = {
    buildMachines = lib.mkForce [ ];
  };

  programs = {
    adb.enable = true;
    light.enable = true;
    steam.enable = true;
  };

  services = {
    btrfs.autoScrub.enable = true;

    cpupower-gui.enable = true;

    kmonad.configfiles = [ ./main.kbd ];

    pipewire.lowLatency.enable = true;

    printing.enable = true;

    ratbagd.enable = true;

    udev.extraRules = ''
      # add my android device to adbusers
      SUBSYSTEM=="usb", ATTR{idVendor}=="22d9", MODE="0666", GROUP="adbusers"
    '';

    xserver = {
      videoDrivers = [ "amdgpu" ];
      desktopManager.gnome.sessionPath = with pkgs.gnomeExtensions; [ ideapad-mode ];
    };

    zerotierone = {
      enable = true;
      joinNetworks = [ "af415e486f732fbc" ];
    };
  };
}
