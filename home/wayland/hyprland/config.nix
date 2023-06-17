{
  config,
  default,
  ...
}: let
  inherit (default) colors;

  pointer = config.home.pointerCursor;
  homeDir = config.home.homeDirectory;
in {
  wayland.windowManager.hyprland.config = {
    "$mod" = "SUPER";
    env = [
      "_JAVA_AWT_WM_NONREPARENTING,1"
      "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
    ];
    exec-once = [
      # scale apps
      "xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2"
      # set cursor for HL itself
      "hyprctl setcursor ${pointer.name} ${toString pointer.size}"
      "systemctl --user start clight"
      "eww open bar"
    ];
    misc = {
      # disable auto polling for config file changes
      disable_autoreload = true;
      # disable dragging animation
      animate_mouse_windowdragging = false;
      # enable variable refresh rate (effective depending on hardware)
      vrr = 1;
    };
    gestures = {
      workspace_swipe = true;
      workspace_swipe_forever = true;
    };

    input = {
      kb_layout = "ro";

      # focus change on cursor move
      follow_mouse = 1;
      accel_profile = "flat";
      touchpad = {
        scroll_factor = 0.3;
      };
    };

    "device:MSFT0001:00 04F3:31EB Touchpad" = {
      accel_profile = "adaptive";
      natural_scroll = true;
      sensitivity = 0.1;
    };
    "device:elan1200:00-04f3:3090-touchpad" = {
      accel_profile = "adaptive";
      natural_scroll = true;
      sensitivity = 0.1;
    };
    general = {
      gaps_in = 5;
      gaps_out = 5;
      border_size = 2;
      "col.active_border" = "rgb(${colors.blue}) rgb(${colors.mauve}) 270deg";
      "col.inactive_border" = "rgb(${colors.base}) rgb(${colors.lavender}) 270deg";

      # group borders
      "col.group_border_active" = "rgb(${colors.pink})";
      "col.group_border" = "rgb(${colors.surface0})";
    };

    decoration = {
      rounding = 16;
      blur = true;
      blur_size = 3;
      blur_passes = 3;
      blur_new_optimizations = true;

      drop_shadow = true;
      shadow_ignore_window = true;
      shadow_offset = "0 5";
      shadow_range = 50;
      shadow_render_power = 3;
      "col.shadow" = "rgba(00000099)";
    };

    animations = {
      enabled = true;
      animation = [
        "border, 1, 2, default"
        "fade, 1, 4, default"
        "windows, 1, 3, default, popin 80%"
        "workspaces, 1, 2, default, slide"
      ];
    };

    dwindle = {
      # keep floating dimentions while tiling
      pseudotile = true;
      preserve_split = true;
    };

    windowrulev2 = [
      # only allow shadows for floating windows
      "noshadow, floating:0"

      # telegram media viewer
      "float, title:^(Media viewer)$"

      # make Firefox PiP window floating and sticky
      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"

      # throw sharing indicators away
      "workspace special silent, title:^(Firefox — Sharing Indicator)$"
      "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"

      # start spotify tiled in ws9
      "tile, title:^(Spotify)$"
      "workspace 9 silent, title:^(Spotify)$"

      # start Discord/WebCord in ws2
      "workspace 2, title:^(.*(Disc|WebC)ord.*)$"

      # idle inhibit while watching videos
      "idleinhibit focus, class:^(mpv|.+exe)$"
      "idleinhibit focus, class:^(firefox)$, title:^(.*YouTube.*)$"
      "idleinhibit fullscreen, class:^(firefox)$"

      "dimaround, class:^(gcr-prompter)$"

      # fix xwayland apps
      "rounding 0, xwayland:1, floating:1"
      "center, class:^(.*jetbrains.*)$, title:^(Confirm Exit|Open Project|win424|win201|splash)$"
      "size 640 400, class:^(.*jetbrains.*)$, title:^(splash)$"
    ];
    layerrule = [
      "blur, ^(gtk-layer-shell|anyrun)$"
      "ignorezero, ^(gtk-layer-shell|anyrun)$"
    ];
    bindm = [
      # mouse movements
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
      "$mod ALT, mouse:272, resizewindow"
    ];

    # toggle "monocle" (no_gaps_when_only)
    "$kw" = "dwindle:no_gaps_when_only";
    bind =
      [
        # compositor commands
        "$mod SHIFT, E, exec, pkill Hyprland"
        "$mod, Q, killactive,"
        "$mod, F, fullscreen,"
        "$mod, G, togglegroup,"
        "$mod SHIFT, N, changegroupactive, f"
        "$mod SHIFT, P, changegroupactive, b"
        "$mod, R, togglesplit,"
        "$mod, T, togglefloating,"
        "$mod, P, pseudo,"
        "$mod ALT, ,resizeactive,"
        "$mod, M, exec, hyprctl keyword $kw $(($(hyprctl getoption $kw -j | jaq -r '.int') ^ 1))"

        # utility
        # launcher
        # terminal
        "$mod, Return, exec, run-as-service ${default.terminal.name}"
        # logout menu
        "$mod, Escape, exec, wlogout -p layer-shell"
        # lock screen
        "$mod, L, exec, loginctl lock-session"
        # select area to perform OCR on
        "$mod, O, exec, run-as-service wl-ocr"

        # move focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # window resize
        "$mod, S, submap, resize"

        # window resize
        ''
          $mod, S, submap, resize
          submap = resize
          binde = , right, resizeactive, 10 0
          binde = , left, resizeactive, -10 0
          binde = , up, resizeactive, 0 -10
          binde = , down, resizeactive, 0 10
          bind = , escape, submap, reset
          submap = reset
        ''

        ", XF86AudioMute, exec, ${homeDir}/.config/eww/scripts/volume osd"
        ", XF86AudioMute, exec, ${homeDir}/.config/eww/scripts/volume osd"

        ", Print, exec, grimblast --notify copysave area"
        "$mod SHIFT, R, exec, grimblast --notify copysave area"
        "CTRL, Print, exec, grimblast --notify --cursor copysave output"
        "$mod SHIFT CTRL, R, exec, grimblast --notify --cursor copysave output"
        "ALT, Print, exec, grimblast --notify --cursor copysave screen"
        "$mod SHIFT ALT, R, exec, grimblast --notify --cursor copysave screen"
        "$mod SHIFT, grave, movetoworkspace, special"
        "$mod, grave, togglespecialworkspace, eDP-1"
        "$mod, bracketleft, workspace, m-1"
        "$mod, bracketright, workspace, m+1"
        "$mod SHIFT, braceleft, focusmonitor, l"
        "$mod SHIFT, braceright, focusmonitor, r"
      ]
      ++ (
        builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10)
      );

    bindr = [
      "$mod, SUPER_L, exec, pkill .${default.launcher}-wrapped || run-as-service ${default.launcher}"
    ];

    bindl = [
      # media controls
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ];

    binde = [
      ", XF86AudioRaiseVolume, exec, ${homeDir}/.config/eww/scripts/volume osd"
      ", XF86AudioLowerVolume, exec, ${homeDir}/.config/eww/scripts/volume osd"
      ", XF86MonBrightnessUp, exec, ${homeDir}/.config/eww/scripts/brightness osd"
      ", XF86MonBrightnessDown, exec, ${homeDir}/.config/eww/scripts/brightness osd"
    ];

    bindle = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l \"1.0\" @DEFAULT_AUDIO_SINK@ 6%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume -l \"1.0\" @DEFAULT_AUDIO_SINK@ 6%-"
      ", XF86MonBrightnessUp, exec, brillo -q -u 300000 -A 5"
      ", XF86MonBrightnessDown, exec, brillo -q -u 300000 -U 5"
    ];
  };
}
