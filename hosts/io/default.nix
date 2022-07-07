{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  # binfmt
  boot.binfmt.emulatedSystems = ["aarch64-linux" "riscv64-linux"];

  # kernel
  boot.extraModulePackages = with config.boot.kernelPackages; [acpi_call];
  boot.kernelModules = ["acpi_call" "amdgpu"];
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  # dcfeaturemask - PSR support
  boot.kernelParams = ["amdgpu.dcfeaturemask=0x8"];

  # bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  # boot.plymouth.enable = true;

  environment.systemPackages = [config.boot.kernelPackages.cpupower];

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

    opentabletdriver.enable = true;

    video.hidpi.enable = true;

    xpadneo.enable = true;
  };

  networking.hostName = "io";

  programs = {
    adb.enable = true;
    light.enable = true;
    steam.enable = true;
  };

  services = {
    btrfs.autoScrub.enable = true;

    kmonad.keyboards = {
      io = {
        name = "io";
        device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
        defcfg = {
          enable = true;
          fallthrough = true;
          allowCommands = false;
        };
        config = builtins.readFile "${inputs.self}/modules/main.kbd";
      };
    };

    pipewire.lowLatency.enable = true;

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

    xserver.enable = lib.mkForce false;
  };

  # https://github.com/NixOS/nixpkgs/issues/114222
  systemd.user.services.telephony_client.enable = false;
}
