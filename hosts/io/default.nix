{
  config,
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
    initrd = {
      systemd.enable = true;
      supportedFilesystems = ["ext4"];
    };

    # load modules on boot
    kernelModules = ["acpi_call" "amdgpu" "amd_pstate"];

    # use latest kernel
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    # Panel Self Refresh
    kernelParams = ["amdgpu.dcfeaturemask=0x8" "initcall_blacklist=acpi_cpufreq_init" "amd_pstate=passive" "amd_pstate.shared_mem=1"];

    loader = {
      # systemd-boot on UEFI
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };

    plymouth.enable = true;
  };

  environment.systemPackages = [config.boot.kernelPackages.cpupower];

  hardware = {
    bluetooth = {
      enable = true;
      # battery info support
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

    cpu.amd.updateMicrocode = true;

    enableRedistributableFirmware = true;

    opentabletdriver.enable = true;

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
    # enable hyprland and required options
    hyprland.enable = true;

    # backlight control
    light.enable = true;

    steam.enable = true;
  };

  security.tpm2 = {
    enable = true;
    abrmd.enable = true;
  };

  services = {
    # for SSD/NVME
    fstrim.enable = true;

    howdy = {
      enable = true;
      package = inputs.self.packages.${pkgs.system}.howdy;
      settings = {
        core.no_confirmation = true;
        video.dark_threshold = 90;
      };
    };

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

    linux-enable-ir-emitter = {
      enable = true;
      package = inputs.self.packages.${pkgs.system}.linux-enable-ir-emitter;
    };

    # see https://github.com/fufexan/nix-gaming/#pipewire-low-latency
    pipewire.lowLatency.enable = true;

    printing.enable = true;

    # configure mice
    ratbagd.enable = true;

    # power saving
    tlp = {
      enable = true;
      settings = {
        PCIE_ASPM_ON_BAT = "powersupersave";
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "conservative";
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

    # add hyprland to display manager sessions
    xserver.displayManager.sessionPackages = [inputs.hyprland.packages.${pkgs.hostPlatform.system}.default];
  };

  # https://github.com/NixOS/nixpkgs/issues/114222
  systemd.user.services.telephony_client.enable = false;
}
