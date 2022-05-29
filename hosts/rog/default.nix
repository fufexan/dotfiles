{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  # kernel
  boot.extraModulePackages = with config.boot.kernelPackages; [acpi_call];
  boot.kernelModules = ["acpi_call"];
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  # watchdog - supposedly conserves battery
  # dcfeaturemask - PSR support
  # boot.kernelParams = ["nmi_watchdog=0"];

  # bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
    };
  };

  boot.plymouth = {
    enable = true;
    theme = "breeze";
  };

  hardware = {
    bluetooth = {
      enable = true;
      disabledPlugins = ["sap"];
      hsphfpd.enable = true;
      package = pkgs.bluezFull;
      powerOnBoot = false;
      settings = {
        # make Xbox Series X controller work
        General = {
          Class = "0x000100";
          FastConnectable = true;
          JustWorksRepairing = "always";
          Privacy = "device";
        };
      };
    };

    cpu.intel.updateMicrocode = true;

    enableAllFirmware = true;

    opentabletdriver.enable = true;
  };

  networking.hostName = "rog";

  # powerManagement.powertop.enable = true;

  programs = {
    adb.enable = true;
    light.enable = true;
    steam.enable = true;
  };

  services = {
    kmonad.configfiles = [./main.kbd];

    # pipewire.lowLatency.enable = true;

    power-profiles-daemon.enable = false;

    ratbagd.enable = true;

    tlp = {
      enable = true;
      settings = {
        DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
      };
    };

    xserver.enable = lib.mkForce false;

    udev.extraRules = ''
      # add my android device to adbusers
      SUBSYSTEM=="usb", ATTR{idVendor}=="22d9", MODE="0666", GROUP="adbusers"
    '';
  };
}
