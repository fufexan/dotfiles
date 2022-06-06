{
  config,
  pkgs,
  lib,
  ...
}: {
  #imports = [./waybar];

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "swaylock -fF";
      }
      {
        event = "lock";
        command = "swaylock -fF";
      }
    ];
    timeouts = [
      {
        timeout = 300;
        command = "swaymsg output * dpms off";
        resumeCommand = "swaymsg output * dpms on";
      }
      {
        timeout = 360;
        command = "swaylock -fF";
      }
    ];
  };

  wayland.windowManager.sway = {
    enable = true;
    config = {
      assigns = {
        "1: web" = [{class = "^Firefox$";}];
        "2: chat" = [{class = "^Discord$";}];
        "0: media" = [
          {class = "^Spotify$";}
          {class = "^mpv$";}
        ];
      };

      keybindings = let
        sway = config.wayland.windowManager.sway.config;
        grim = "${pkgs.grim}/bin/grim";
        slurp = "${pkgs.slurp}/bin/slurp";
        wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
        m = sway.modifier;

        # toggle output scaling
        output = "eDP-1";
        # toggle-scaling = pkgs.writeShellScript "sway-scale-toggle" ''
        #   S=$(${pkgs.sway}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq '.[] | select(any(. == "${output}")).scale')
        #   [ $S = 2 ] && S=1 || S=2
        #   swaymsg output "${output}" scale $S
        # '';
      in
        lib.mkOptionDefault {
          "${m}+Return" = "exec ${sway.terminal}";
          "${m}+q" = "kill";
          "${m}+space" = "exec ${sway.menu}";
          # Fn + F7
          # "${m}+semicolon" = "exec ${toggle-scaling}";
          # screenshots
          "Print" = ''exec ${grim} -g $(${slurp}) - | ${wl-copy} -t image/png'';
          "${m}+Shift+r" = ''exec ${grim} -g $(${slurp}) - | ${wl-copy} -t image/png'';
          "Ctrl+Print" = "exec ${grim} -c - ~/Pictures/Screenshots/$(date '+%F_%T').png";
          "${m}+Ctrl+Shift+r" = ''exec ${grim} -c - ~/Pictures/Screenshots/$(date '+%F_%T').png'';
        };

      keycodebindings = {
        "--locked --no-repeat 121" = "exec pulsemixer --toggle-mute"; # mute
        "--locked 122" = "exec pulsemixer --change-volume -6"; # vol-
        "--locked 123" = "exec pulsemixer --change-volume +6"; # vol+
        "--locked 171" = "exec playerctl next"; # next song
        "--locked --no-repeat 172" = "exec playerctl play-pause"; # play/pause
        "--locked 173" = "exec playerctl previous"; # prev song
        "--locked --no-repeat 198" = "exec amixer set Capture toggle"; # mic mute
        "--locked 232" = "exec light -U 5"; # brightness-
        "--locked 233" = "exec light -A 5"; # brightness+
      };

      menu = "${pkgs.wofi}/bin/wofi --show drun --allow-images";
      terminal = "alacritty";
      modifier = "Mod4";
      bars = [];

      gaps = {
        smartGaps = true;
        smartBorders = "on";
        outer = 5;
        inner = 5;
      };

      startup = [
        {command = "dbus-update-activation-environment --systemd";}
        {command = "eww daemon; eww open bar";}
        {command = "mako";}
      ];

      input = {
        "type:pointer" = {
          accel_profile = "flat";
          pointer_accel = "0";
        };
        "type:touchpad" = {
          click_method = "clickfinger";
          middle_emulation = "enabled";
          natural_scroll = "enabled";
          tap = "enabled";
        };
      };

      output = {
        "*" = {
          bg = "~/.config/wallpaper.jpg fill";
          max_render_time = "7";
        };
      };
    };

    extraConfig = ''
      smart_borders on
      smart_gaps on
    '';

    wrapperFeatures = {gtk = true;};
  };
}
