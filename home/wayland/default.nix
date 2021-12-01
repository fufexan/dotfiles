{ config, pkgs, ... }:

# Wayland config

{
  imports = [ ./waybar ];

  home.packages = with pkgs; [
    # screenshot
    grim
    slurp

    # idle/lock
    swayidle
    swaylock

    # wm
    wayfire

    # utils
    wl-clipboard
    wlogout
    wofi
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    XDG_CURRENT_DESKTOP = "wayfire";
  };

  programs = {
    firefox.package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      forceWayland = true;
      extraPolicies = {
        ExtensionSettings = { };
      };
    };

    mako = {
      enable = true;
      borderRadius = 10;
      borderSize = 0;
      defaultTimeout = 5000;
      font = "Roboto Regular 10";
      margin = "4,4";
    };
  };

  services = {
    kanshi = {
      enable = true;
      profiles = {
        undocked = {
          outputs = [
            {
              criteria = "eDP-1";
              scale = 2.0;
            }
          ];
        };
        docked-all = {
          outputs = [
            {
              criteria = "eDP-1";
              scale = 2.0;
              position = "1366,0";
            }
            {
              criteria = "DP-1";
              position = "0,0";
            }
            {
              criteria = "DP-2";
              position = "1280,0";
            }
          ];
        };

        docked1 = {
          outputs = [
            {
              criteria = "eDP-1";
              scale = 2.0;
              position = "0,0";
            }
            {
              criteria = "DP-1";
              position = "1280,0";
            }
          ];
        };

        docked2 = {
          outputs = [
            {
              criteria = "eDP-1";
              scale = 2.0;
              position = "0,0";
            }
            {
              criteria = "DP-2";
              position = "1280,0";
            }
          ];
        };
      };
      systemdTarget = "graphical-session.target";
    };

    wlsunset = {
      enable = true;
      latitude = "46.0";
      longitude = "23.0";
    };
  };

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
}
