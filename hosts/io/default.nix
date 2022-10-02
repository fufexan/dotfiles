{
  config,
  lib,
  pkgs,
  inputs,
  ...
} @ args: {
  imports = [./hardware-configuration.nix];

  age.secrets.spotify = {
    file = "${inputs.self}/secrets/spotify.age";
    owner = "mihai";
    group = "users";
  };

  boot = {
    binfmt.emulatedSystems = ["aarch64-linux" "riscv64-linux"];

    extraModulePackages = with config.boot.kernelPackages; [acpi_call];
    kernelModules = ["acpi_call" "amdgpu"];
    kernelPackages = pkgs.linuxPackages_xanmod_latest;

    # Panel Self Refresh support
    kernelParams = ["amdgpu.dcfeaturemask=0x8"];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "dm_mod"
        "tpm"
      ];
      kernelModules = [
        "btrfs"
        "kvm-amd"
        "sd_mod"
        "dm_mod"
      ];
      supportedFilesystems = ["btrfs"];
      # systemd = {
      #   enable = true;
      #   emergencyAccess = true;
      # };
    };
  };
  # boot.plymouth.enable = true;

  environment.systemPackages = [config.boot.kernelPackages.cpupower];

  hardware = {
    bluetooth = {
      enable = true;
      hsphfpd.enable = true;
      settings = {
        # make Xbox Series X controller work
        General = {
          Class = "0x000100";
          FastConnectable = true;
          JustWorksRepairing = "always";
          Privacy = "device";
          Experimental = true;
        };
      };
    };

    cpu.amd.updateMicrocode = true;

    enableRedistributableFirmware = true;

    video.hidpi.enable = true;

    xpadneo.enable = true;
  };

  networking = {
    hostName = "io";
    firewall = {
      allowedTCPPorts = [42355];
      allowedUDPPorts = [5353];
    };
  };

  programs = {
    adb.enable = true;
    hyprland = {
      enable = true;
      package = null;
    };
    light.enable = true;
    steam.enable = true;
  };

  security.tpm2 = {
    enable = true;
    abrmd.enable = true;
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
        NMI_WATCHDOG = 0;
      };
    };

    udev.extraRules = let
      inherit (import ./plugged.nix args) plugged unplugged;
    in ''
      # add my android device to adbusers
      SUBSYSTEM=="usb", ATTR{idVendor}=="22d9", MODE="0666", GROUP="adbusers"

      # start/stop services on power (un)plug
      SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${plugged}"
      SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${unplugged}"
    '';

    xserver.enable = lib.mkForce false;
  };

  # https://github.com/NixOS/nixpkgs/issues/114222
  systemd.user.services.telephony_client.enable = false;
}
