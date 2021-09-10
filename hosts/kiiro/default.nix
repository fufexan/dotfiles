# symbolistic yellow; main pc
{ config, lib, pkgs, agenix, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  age.secrets = {
    mailPassPlain = {
      file = ../../secrets/mailPassPlain.age;
      owner = "mihai";
    };
  };

  # kernel
  boot.kernelPackages = pkgs.linuxPackages_xanmod;
  # modules to load
  boot.kernelModules = [ "v4l2loopback" ];
  # make modules available to modprobe
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

  # bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  hardware = {
    bluetooth = {
      enable = true;
      disabledPlugins = [ "sap" ];
      package = pkgs.bluezFull;
      powerOnBoot = false;
    };

    cpu.intel.updateMicrocode = true;

    enableAllFirmware = true;

    nvidia.modesetting.enable = true;

    opentabletdriver.enable = true;

    pulseaudio.enable = lib.mkForce false;
  };

  networking.hostName = "kiiro";

  programs = {
    adb.enable = true;
    steam.enable = true;
  };

  services = {
    btrfs.autoScrub.enable = true;

    pipewire.lowLatency.enable = true;

    printing.enable = true;

    ratbagd.enable = true;

    udev.extraRules = ''
      # bfq for HDD
      ACTION=="add|change", KERNEL=="sda", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
      # add my android device to adbusers
      SUBSYSTEM=="usb", ATTR{idVendor}=="22d9", MODE="0666", GROUP="adbusers"
      # make WoL persistent
      ACTION=="add", SUBSYSTEM=="net", NAME=="enp3s0", RUN+="${pkgs.ethtool}/bin/ethtool -s enp3s0 wol g"
    '';

    xserver = {
      displayManager.gdm.nvidiaWayland = true;
      windowManager.bspwm.enable = true;

      videoDrivers = [ "nvidia" ];
    };

    zerotierone = {
      enable = true;
      joinNetworks = [ "af415e486f732fbc" ];
    };
  };
}
