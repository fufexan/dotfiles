{ config, pkgs, lib, ... }:

# Wayland config

{
  #imports = [ ./waybar ];

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
    #XDG_CURRENT_DESKTOP = "sway";
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
      enable = false;
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
      enable = false;
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

  wayland.windowManager.sway = {
    enable = true;
    config = {
      keybindings =
        let
          sway = config.wayland.windowManager.sway.config;
          m = sway.modifier;
        in
        lib.mkOptionDefault {
          "${m}+Return" = "exec ${sway.terminal}";
          "${m}+q" = "kill";
          "${m}+d" = "exec ${sway.menu}";
        };
      menu = "${pkgs.wofi}/bin/wofi --show drun";
      terminal = "alacritty";
      modifier = "Mod4";
      bars = [ ];
      input = {
        "type:pointer" = {
          accel_profile = "flat";
          pointer_accel = "0";
        };
      };
      output = {
        "*" = {
          bg = "~/Pictures/wallpapers/neon/citysunset.jpg fill";
          #max_render_time = "7";
          scale = "1";
        };
      };
    };
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    '';
    wrapperFeatures = { gtk = true; };
  };
}
