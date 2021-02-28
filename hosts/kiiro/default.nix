# symbolistic yellow; main pc
{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # kernel
  boot.kernelPackages = pkgs.linuxPackages_lqx;
  boot.kernelPatches = [
    {
      name = "snd-usb-audio-patch";
      patch = ../modules/linux591-snd-usb-audio.patch;
    }
  ];
  # modules to load
  boot.kernelModules = [ "v4l2loopback" ];
  # configure modules loaded by modprobe
  boot.extraModprobeConfig = ''
    options snd-usb-audio max_packs=1 max_packs_hs=1 max_urbs=12 sync_urbs=4 max_queue=18
  '';
  # make modules available to modprobe
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  # browser fix on Intel CPUs
  boot.kernelParams = [ "intel_pstate=active" ];

  # bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    systemd-boot.consoleMode = "max";
  };

  environment.systemPackages = with pkgs; [ virt-manager ];

  # Japanese input using fcitx
  i18n.inputMethod = {
    enabled = "fcitx";
    fcitx.engines = with pkgs.fcitx-engines; [ anthy mozc ];
  };

  # network
  networking = {
    hostName = "kiiro";
    interfaces.enp3s0.useDHCP = true;
  };
  networking.firewall.enable = false;

  # enable programs
  programs.adb.enable = true;
  programs.steam.enable = true;

  # pipewire
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
  };

  services.dbus.packages = [ pkgs.gnome3.dconf ];

  virtualisation.libvirtd.enable = true;
}
