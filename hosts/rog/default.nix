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

  environment.systemPackages = let
    nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec -a "$0" "$@"
    '';
  in [nvidia-offload];

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

    enableRedistributableFirmware = true;

    opentabletdriver.enable = true;

    opengl = {
      extraPackages = with pkgs; [vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl];
      extraPackages32 = with pkgs.pkgsi686Linux; [vaapiIntel libvdpau-va-gl vaapiVdpau];
    };

    nvidia = {
      modesetting.enable = true;
      prime = {
        offload.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  networking.hostName = "rog";
  networking.firewall.enable = lib.mkForce false;

  nix.buildMachines = lib.mkForce [];

  powerManagement.powertop.enable = true;

  programs = {
    adb.enable = true;
    light.enable = true;
    steam.enable = true;
  };

  services = {
    dbus.packages = [pkgs.gcr];

    kmonad.keyboards = {
      rog = {
        device = "/dev/input/by-path/pci-0000:00:14.0-usb-0:8:1.0-event-kbd";
        defcfg = {
          enable = true;
          fallthrough = true;
          allowCommands = false;
        };
        config = builtins.readFile "${inputs.self}/modules/main.kbd";
      };
    };

    pipewire.lowLatency.enable = true;

    power-profiles-daemon.enable = false;

    ratbagd.enable = true;

    tlp = {
      enable = true;
      settings = {
        DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
      };
    };

    xserver.displayManager.gdm.enable = lib.mkForce false;
    xserver.displayManager.startx.enable = true;
    xserver.videoDrivers = ["nvidia"];

    udev.extraRules = ''
      # add my android device to adbusers
      SUBSYSTEM=="usb", ATTR{idVendor}=="22d9", MODE="0666", GROUP="adbusers"
    '';
  };
}
