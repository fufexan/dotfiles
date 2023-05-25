{
  config,
  pkgs,
  lib,
  default,
  ...
}: {
  wayland.windowManager.sway = {
    enable = true;

    config = {
      keybindings = let
        m = config.wayland.windowManager.sway.config.modifier;
      in
        lib.mkOptionDefault {
          "${m}+Return" = "exec ${default.terminal.name}";
          "${m}+q" = "kill";
          "${m}+space" = "exec ${default.launcher}";
          "${m}+t" = "floating toggle";

          # screenshots
          "Print" = "grim -g \"$(slurp)\" - | wl-copy -t image/png";
          "${m}+Shift+r" = "grim -g \"$(slurp)\" - | wl-copy -t image/png";
          "Alt+Print" = "grim - | wl-copy -t image/png";
          "${m}+Alt+Shift+r" = "grim - | wl-copy -t image/png";
        };

      keycodebindings = {
        "--locked --no-repeat 121" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; # mute
        "--locked 122" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%-"; # vol-
        "--locked 123" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%+"; # vol+
        "--locked 171" = "exec playerctl next"; # next song
        "--locked --no-repeat 172" = "exec playerctl play-pause"; # play/pause
        "--locked 173" = "exec playerctl previous"; # prev song
        "--locked --no-repeat 198" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; # mic mute
        "--locked 232" = "exec brillo -q -u 300000 -U 5"; # brightness-
        "--locked 233" = "exec brillo -q -u 300000 -A 5"; # brightness+
      };

      menu = default.launcher;
      terminal = default.terminal.name;
      modifier = "Mod4";
      bars = [];

      gaps = {
        smartBorders = "on";
        outer = 5;
        inner = 5;
      };

      startup = [{command = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY";}];

      input = {
        "type:pointer" = {
          accel_profile = "flat";
          pointer_accel = "0";
        };
        "type:touchpad" = {
          middle_emulation = "enabled";
          natural_scroll = "enabled";
          tap = "enabled";
        };
      };
      output."*".bg = "~/.config/wallpaper.png fill";
    };

    extraConfig = ''
      exec ${pkgs.xorg.xprop}/bin/xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2
    '';

    wrapperFeatures.gtk = true;
  };
}
