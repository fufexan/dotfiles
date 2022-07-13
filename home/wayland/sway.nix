{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
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
    package = inputs.self.packages.${pkgs.system}.sway-hidpi;
    config = {
      keybindings = let
        sway = config.wayland.windowManager.sway.config;
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

          "${m}+t" = "floating toggle";

          # Fn + F7
          # "${m}+semicolon" = "exec ${toggle-scaling}";

          # screenshots
          "Print" = "screenshot area";
          "${m}+Shift+r" = "screenshot area";
          "Ctrl+Print" = "screenshot monitor";
          "${m}+Ctrl+Shift+r" = "screenshot monitor";
          "Alt+Print" = "screenshot all";
          "${m}+Alt+Shift+r" = "screenshot all";
        };

      keycodebindings = {
        "--locked --no-repeat 121" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; # mute
        "--locked 122" = "exec pulsemixer --change-volume -6"; # vol-
        "--locked 123" = "exec pulsemixer --change-volume +6"; # vol+
        "--locked 171" = "exec playerctl next"; # next song
        "--locked --no-repeat 172" = "exec playerctl play-pause"; # play/pause
        "--locked 173" = "exec playerctl previous"; # prev song
        "--locked --no-repeat 198" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; # mic mute
        "--locked 232" = "exec light -U 5"; # brightness-
        "--locked 233" = "exec light -A 5"; # brightness+
      };

      menu = "${pkgs.wofi}/bin/wofi --show drun --allow-images -iq";
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
        {command = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY";}
        {command = "systemctl --user start graphical-session{-pre,}.target";}
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
          # max_render_time = "7";
        };
      };
    };

    extraConfig = ''
      xwayland force scale 2
      exec xsettingsd
    '';

    wrapperFeatures = {gtk = true;};
  };

  xdg.configFile."xsettingsd/xsettingsd.conf".text = "Gdk/WindowScalingFactor 2";
}
