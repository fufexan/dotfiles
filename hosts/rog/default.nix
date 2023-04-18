{
  config,
  lib,
  pkgs,
  inputs,
  ...
} @ args: {
  imports = [./hardware-configuration.nix];

  # kernel
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [acpi_call];
    kernelModules = ["acpi_call"];
    kernelPackages = pkgs.linuxPackages_xanmod_latest;

    # make 3.5mm jack work
    extraModprobeConfig = ''
      options snd_hda_intel model=headset-mode
    '';
  };

  # bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  boot.plymouth.enable = true;

  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.bluez5-experimental;
      settings = {
        # make Xbox Series X controller work
        General = {
          Class = "0x000100";
          ControllerMode = "bredr";
          FastConnectable = true;
          JustWorksRepairing = "always";
          Privacy = "device";
          Experimental = true;
        };
      };
    };

    cpu.intel.updateMicrocode = true;

    enableAllFirmware = true;

    opentabletdriver.enable = true;

    opengl = {
      extraPackages = with pkgs; [vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl];
      extraPackages32 = with pkgs.pkgsi686Linux; [vaapiIntel libvdpau-va-gl vaapiVdpau];
    };

    nvidia = {
      modesetting.enable = true;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  networking.hostName = "rog";
  networking.firewall.enable = lib.mkForce false;

  nixpkgs.config.allowUnfree = true;

  programs = {
    hyprland = {
      enable = true;
      nvidiaPatches = true;
    };
    light.enable = true;
    steam.enable = true;
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
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

    ratbagd.enable = true;

    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "conservative";
        NMI_WATCHDOG = 0;
      };
    };

    xserver.videoDrivers = ["nvidia"];

    udev.extraRules = let
      inherit (import ./plugged.nix args) plugged unplugged;
    in ''
      # add my android device to adbusers
      SUBSYSTEM=="usb", ATTR{idVendor}=="22d9", MODE="0666", GROUP="adbusers"

      # start/stop services on power (un)plug
      SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${plugged}"
      SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${unplugged}"
    '';
  };

  # https://github.com/NixOS/nixpkgs/issues/114222
  systemd.user.services.telephony_client.enable = false;
}
