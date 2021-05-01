# symbolistic yellow; main pc
{ config, pkgs, agenix, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  age.secrets = {
    mailPassPlain = {
      file = ../../secrets/mailPassPlain.age;
      owner = "mihai";
    };
  };

  # kernel
  boot.kernelPackages = pkgs.linuxPackages_lqx;
  # modules to load
  boot.kernelModules = [ "v4l2loopback" ];
  # make modules available to modprobe
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

  # bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  # enable Nvidia KMS (for Wayland and less screen tearing on Xorg)
  hardware.nvidia.modesetting.enable = true;
  hardware.opentabletdriver.enable = true;

  networking = {
    hostName = "kiiro";
    interfaces.enp3s0.useDHCP = true;
  };

  programs = {
    adb.enable = true;
    steam.enable = true;
  };

  services = {
    btrfs.autoScrub.enable = true;

    mopidy = {
      enable = true;
      #dataDir = "/home/mihai/.config/mopidy";
      extensionPackages = [
        pkgs.mopidy-local
        pkgs.mopidy-mpd
        pkgs.mopidy-mpris
        pkgs.mopidy-soundcloud
        pkgs.mopidy-spotify
        pkgs.mopidy-youtube
      ];
    };

    printing = {
      enable = true;
      drivers = [ pkgs.fxlinuxprint ];
    };

    ratbagd.enable = true;

    udev.extraRules = ''
      ACTION=="add|change", KERNEL=="sda", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
    '';

    xserver.videoDrivers = [ "nvidia" ];
  };

  virtualisation.libvirtd.enable = true;
  environment.systemPackages = with pkgs; [ virt-manager ];
}
