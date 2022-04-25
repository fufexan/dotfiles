{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  # kernel
  boot.extraModulePackages = with config.boot.kernelPackages; [acpi_call];
  boot.kernelModules = ["acpi_call" "amdgpu"];
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  # watchdog - supposedly conserves battery
  # dcfeaturemask - PSR support
  boot.kernelParams = ["nmi_watchdog=0" "amdgpu.dcfeaturemask=0x8"];

  # bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  boot.plymouth.enable = true;

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

    cpu.amd.updateMicrocode = true;

    enableAllFirmware = true;

    openrazer = {
      enable = true;
      users = ["mihai"];
    };

    opentabletdriver.enable = true;

    xpadneo.enable = true;
  };

  networking.hostName = "io";

  powerManagement.powertop.enable = true;

  programs = {
    adb.enable = true;
    light.enable = true;
    steam.enable = true;
  };

  services = {
    btrfs.autoScrub.enable = true;

    kmonad.configfiles = [./main.kbd];

    pipewire.lowLatency.enable = true;

    power-profiles-daemon.enable = false;

    printing.enable = true;

    ratbagd.enable = true;

    tlp = {
      enable = true;
      settings = {
        PCIE_ASPM_ON_BAT = "powersupersave";
        DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
      };
    };

    udev.extraRules = ''
      # add my android device to adbusers
      SUBSYSTEM=="usb", ATTR{idVendor}=="22d9", MODE="0666", GROUP="adbusers"
    '';

    xserver.videoDrivers = ["amdgpu"];
  };
}
