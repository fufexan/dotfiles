{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;
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
      package = pkgs.bluezFull;
      powerOnBoot = false;
    };

    cpu.amd.updateMicrocode = true;

    enableAllFirmware = true;

    opengl = {
      extraPackages = with pkgs; [ amdvlk ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ amdvlk ];
    };
  };

  networking.hostName = "io";

  nix = {
    buildMachines = lib.mkForce [ ];
  };

  programs = {
    adb.enable = true;
    light.enable = true;
    steam.enable = true;
  };

  services = {
    kmonad.configfiles = [ ./main.kbd ];

    pipewire.lowLatency.enable = true;

    power-profiles-daemon.enable = false;

    printing.enable = true;

    udev.extraRules = ''
      # add my android device to adbusers
      SUBSYSTEM=="usb", ATTR{idVendor}=="22d9", MODE="0666", GROUP="adbusers"
    '';

    tlp.enable = true;

    xserver = {
      videoDrivers = [ "amdgpu" ];
      desktopManager.gnome.sessionPath = with pkgs.gnomeExtensions; [ ideapad-mode ];
    };

    zerotierone = {
      enable = true;
      joinNetworks = [ "af415e486f732fbc" ];
    };
  };
}
