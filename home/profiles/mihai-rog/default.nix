{lib, ...}: {
  xsession.windowManager.bspwm.monitors = {
    eDP = ["1" "2" "3" "4" "5" "6" "7" "8" "9"];
    DisplayPort-1 = ["1" "2" "3" "4" "5" "6" "7" "8" "9"];
    DisplayPort-2 = ["1" "2" "3" "4" "5" "6" "7" "8" "9"];
  };

  home.keyboard = lib.mkForce null;

  services = let
    inherit (lib) mkForce;
  in {
    dunst.enable = mkForce false;
    flameshot.enable = mkForce false;
    picom.enable = mkForce false;
    polybar.enable = mkForce false;
    random-background.enable = mkForce false;
    redshift.enable = mkForce false;

    kanshi = {
      enable = true;
      profiles = {
        undocked = {outputs = [{criteria = "eDP-1";}];};
        docked = {
          outputs = [
            {
              criteria = "eDP-1";
              position = "0,0";
            }
            {
              criteria = "HDMI-A-1";
              position = "1920,0";
            }
          ];
        };
      };
      systemdTarget = "graphical-session.target";
    };
  };
}
