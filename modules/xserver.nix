{
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;

    libinput = {
      enable = true;
      # disable mouse acceleration
      mouse.accelProfile = "flat";
      mouse.accelSpeed = "0";
      mouse.middleEmulation = false;
      # touchpad settings
      touchpad.naturalScrolling = true;
    };
  };
}
