{
  config,
  pkgs,
  inputs,
  lib,
  self,
  ...
} @ args: {
  imports = [./hardware-configuration.nix];

  age.secrets.spotify = {
    file = "${self}/secrets/spotify.age";
    owner = "mihai";
    group = "users";
  };

  boot = {
    bootspec.enable = true;

    initrd = {
      systemd.enable = true;
      supportedFilesystems = ["ext4"];
    };

    # load modules on boot
    kernelModules = ["acpi_call"];

    # use latest kernel
    kernelPackages = pkgs.linuxPackages_xanmod_latest;

    kernelParams = ["amd_pstate=active"];

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    loader = {
      # systemd-boot on UEFI
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = lib.mkForce false;
    };

    plymouth = {
      enable = true;
      themePackages = [self.packages.${pkgs.hostPlatform.system}.catppuccin-plymouth];
      theme = "catppuccin-mocha";
    };
  };

  environment.systemPackages = [
    config.boot.kernelPackages.cpupower
    pkgs.sbctl
  ];

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

    # smooth backlight control
    brillo.enable = true;

    cpu.amd.updateMicrocode = true;

    enableRedistributableFirmware = true;

    opentabletdriver.enable = true;

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
    steam.enable = true;
    sway.enable = true;
  };

  security.tpm2 = {
    enable = true;
    abrmd.enable = true;
  };

  services = {
    # for SSD/NVME
    fstrim.enable = true;

    kmonad.keyboards = {
      io = {
        name = "io";
        device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
        defcfg = {
          enable = true;
          fallthrough = true;
          allowCommands = false;
        };
        config = builtins.readFile "${self}/modules/main.kbd";
      };
    };

    logind.extraConfig = ''
      HandlePowerKey=suspend
    '';

    # see https://github.com/fufexan/nix-gaming/#pipewire-low-latency
    pipewire.lowLatency.enable = true;

    printing.enable = true;

    power-profiles-daemon.enable = true;

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
