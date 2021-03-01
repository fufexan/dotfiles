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

    displayManager.sddm.enable = true;

    windowManager.bspwm.enable = true;

    # disable mouse acceleration
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
      mouse.accelSpeed = "0";
    };
  };
}
