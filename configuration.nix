{ config, pkgs, ... }:

{
  imports =
    [
      # the default for the machine
      /etc/nixos/hardware-configuration.nix

      # in case you use Xorg
      ./xorg.nix

      # bootloader config
      ./bootloader.nix

      # networking
      ./network.nix

      # packages to install system-wide
      ./packages.nix

      # in case you play osu! and want low latency
      ./osu.nix

      # user accounts
      ./users.nix

      # configure shells and console
      ./shell.nix

      # fonts
      ./fonts.nix
    ];
  
  # hostname
  networking.hostName = "nixpc";

  # timezone
  time.timeZone = "Europe/Bucharest";

  # internatiolisation
  i18n.defaultLocale = "ro_RO.UTF-8";
  console = {
      font = "Lat2-Terminus16";
      keyMap = "ro";
  };

  # enable 32-bit OpenGL
  hardware.opengl.driSupport32Bit = true;

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
