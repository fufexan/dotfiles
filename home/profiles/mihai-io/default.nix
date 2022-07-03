{lib, ...}: {
  services = {
    kanshi = {
      # use 1.6 scaling: 2560 : 1.6 = 1600, exact division. good for offsets
      # restart eww every time because it won't expand/contract automatically
      enable = true;
      profiles = {
        undocked = {
          exec = "us restart eww";
          outputs = [
            {
              criteria = "eDP-1";
              position = "0,0";
              scale = 1.6;
            }
          ];
        };
        docked-all = {
          exec = "systemctl --user restart eww";
          outputs = [
            {
              criteria = "eDP-1";
              scale = 1.6;
              position = "1366,0";
            }
            {
              criteria = "DP-1";
              position = "0,0";
            }
            {
              criteria = "DP-2";
              position = "1600,0";
            }
          ];
        };

        docked1 = {
          exec = "us restart eww";
          outputs = [
            {
              criteria = "eDP-1";
              scale = 1.6;
              position = "1366,0";
            }
            {
              criteria = "DP-1";
              position = "0,0";
            }
          ];
        };

        docked2 = {
          exec = "us restart eww";
          outputs = [
            {
              criteria = "eDP-1";
              scale = 1.6;
              position = "1366,0";
            }
            {
              criteria = "DP-2";
              position = "0,0";
            }
          ];
        };
      };
      systemdTarget = "graphical-session.target";
    };
  };
}
