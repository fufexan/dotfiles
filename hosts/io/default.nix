{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # kernel
  boot.kernelModules = [ "amdgpu" ];
  # need to figure out which patch fixes amdgpu blank screen after suspend
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

    opentabletdriver.enable = true;
  };

  networking.hostName = "io";

  nix.buildMachines = lib.mkForce [ ];

  programs = {
    adb.enable = true;
    steam.enable = true;
  };

  services = {
    btrfs.autoScrub.enable = true;

    kmonad.configfiles = [ ./main.kbd ];

    journald.extraConfig = lib.mkForce "";

    pipewire.lowLatency.enable = true;

    power-profiles-daemon.enable = false;

    printing.enable = true;

    ratbagd.enable = true;

    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "conservative";
      };
    };

    udev.extraRules = ''
      # add my android device to adbusers
      SUBSYSTEM=="usb", ATTR{idVendor}=="22d9", MODE="0666", GROUP="adbusers"
    '';

    xserver.videoDrivers = [ "amdgpu" ];
  };
}
