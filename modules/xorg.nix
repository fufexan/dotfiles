# Xorg config

{
  services.xserver = {
    enable = true;

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
