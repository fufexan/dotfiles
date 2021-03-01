{ config, pkgs, ... }:

{
  # install packages specific to X
  environment.systemPackages = with pkgs; [
    # gui utils
    maim
    # cli utils
    xclip xorg.xkill xdotool
  ];

  # configure X
  services.xserver = {
    enable = true;

    # keyboard config
    layout = "ro";

    videoDrivers = [ "nvidia" ];

    # display manager setup
    displayManager = {
      defaultSession = "none+bspwm";
      lightdm = {
        background = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
        greeters.gtk = {
          cursorTheme.name = "Capitaine Cursors";
          cursorTheme.package = pkgs.capitaine-cursors;
          theme.name = "Orchis-dark-compact";
          #theme.package = pkgs.orchis;
        };
      };
    };

    windowManager.bspwm.enable = true;

    # disable mouse acceleration
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
      mouse.accelSpeed = "0";
    };
  };
}
