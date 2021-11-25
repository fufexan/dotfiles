{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # kernel
  boot.extraModulePackages = with config.boot.kernelPackages; [ anbox ];
  boot.kernelModules = [ "amdgpu" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPatches = [
    {
      name = "amd_pmc";
      patch = ../../pkgs/amd_pmc.patch;
      extraConfig = "";
    }
  ];
  # supposedly conserves battery
  boot.kernelParams = [ "nmi_watchdog=0" ];

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
    light.enable = true;
    steam.enable = true;
  };

  services = {
    blueman.enable = true;

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

    xserver = {
      videoDrivers = [ "amdgpu" ];

      displayManager.gdm.enable = lib.mkForce false;
      displayManager.startx.enable = true;
      displayManager.session = [
        {
          manage = "window";
          name = "Wayfire";
          start = "exec $HOME/.wl-session";
        }
      ];
    };
  };

  virtualisation.waydroid.enable = true;
}
