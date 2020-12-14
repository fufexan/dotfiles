{ config, pkgs, ... }:

{
  imports =
    [
      # the default for the machine
      /etc/nixos/hardware-configuration.nix

      # bootloader config
      ./bootloader.nix

      # droidcam
      ./droidcam.nix

      # fonts
      ./fonts.nix

      # networking
      ./network.nix

      # in case you want low latency on your Pulseaudio setup
      # mostly applicable to producers and osu! players
      ./pulse.nix

      # packages to install system-wide
      ./packages.nix

      # configure shells and console
      ./shell.nix

      # user accounts
      ./users.nix

      # in case you use Xorg
      ./xorg.nix
    ];
  
  # hostname
  networking.hostName = "nixpc";

  # timezone
  time.timeZone = "Europe/Bucharest";

  # internatiolisation
  i18n.defaultLocale = "ro_RO.UTF-8";

  # disable firewall
  networking.firewall.enable = false;

  # enable open source drivers
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  # enable nvidia modesetting
  #hardware.nvidia.modesetting.enable = true;

  # enable sound
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  # services
  services.openssh.enable = true;

  # system version
  system.stateVersion = "20.09";

  # allow system to auto-upgrade
  system.autoUpgrade.enable = true;
}
