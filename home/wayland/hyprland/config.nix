{
  config,
  default,
  ...
}: let
  inherit (config.programs.matugen) variant;
  c = config.programs.matugen.theme.colors.colors_android.${variant};

  pointer = config.home.pointerCursor;
  scriptDir = "${config.home.homeDirectory}/.config/eww/scripts";
in {
  wayland.windowManager.hyprland.extraConfig = ''
    $mod = SUPER

    env = _JAVA_AWT_WM_NONREPARENTING,1
    env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
    env = WLR_DRM_NO_ATOMIC,1

    # set cursor for HL itself
    exec-once = hyprctl setcursor ${pointer.name} ${toString pointer.size}

    exec-once = systemctl --user start clight
    exec-once = eww open bar
    exec-once = eww open osd

    # use this instead of hidpi patches
    xwayland {
      force_zero_scaling = true
    }

    misc {
      # disable auto polling for config file changes
      disable_autoreload = true

      disable_hypr_chan = true

      # disable dragging animation
      animate_mouse_windowdragging = false

      # enable variable refresh rate (effective depending on hardware)
      vrr = 1

      # groupbar
      groupbar_titles_font_size = 16
      groupbar_gradients = false
    }

    # touchpad gestures
    gestures {
      workspace_swipe = true
      workspace_swipe_forever = true
    }

    input {
      kb_layout = ro

      # focus change on cursor move
      follow_mouse = 1
      accel_profile = flat
      touchpad {
        scroll_factor = 0.3
      }
    }

    device:MSFT0001:00 04F3:31EB Touchpad {
      accel_profile = adaptive
      natural_scroll = true
      sensitivity = 0.1
    }
    device:elan1200:00-04f3:3090-touchpad {
      accel_profile = adaptive
      natural_scroll = true
      sensitivity = 0.1
    }

    general {
      gaps_in = 5
      gaps_out = 5
      border_size = 1
      col.active_border = rgba(88888888)
      col.inactive_border = rgba(00000088)

      # group borders
      col.group_border_active = rgba(${c.color_accent_primary}88)
      col.group_border = rgba(${c.color_accent_primary_variant}88)

      allow_tearing = true
    }

    decoration {
      rounding = 16
      blur {
        enabled = true
        size = 10
        passes = 3
        new_optimizations = true
        brightness = 1.0
        contrast = 1.0
        noise = 0.02
      }

      drop_shadow = true
      shadow_ignore_window = true
      shadow_offset = 0 2
      shadow_range = 20
      shadow_render_power = 3
      col.shadow = rgba(00000055)
    }

    animations {
      enabled = true
      animation = border, 1, 2, default
      animation = fade, 1, 4, default
      animation = windows, 1, 3, default, popin 80%
      animation = workspaces, 1, 2, default, slide
    }

    dwindle {
      # keep floating dimentions while tiling
      pseudotile = true
      preserve_split = true
    }

    plugin {
      csgo-vulkan-fix {
        res_w = 1280
        res_h = 800
      }
    }

    # telegram media viewer
    windowrulev2 = float, title:^(Media viewer)$

    # allow tearing in games
    windowrulev2 = immediate, class:^(osu\!|cs2)$

    # make Firefox PiP window floating and sticky
    windowrulev2 = float, title:^(Picture-in-Picture)$
    windowrulev2 = pin, title:^(Picture-in-Picture)$

    # throw sharing indicators away
    windowrulev2 = workspace special silent, title:^(Firefox — Sharing Indicator)$
    windowrulev2 = workspace special silent, title:^(.*is sharing (your screen|a window)\.)$

    # start spotify tiled in ws9
    windowrulev2 = tile, title:^(Spotify)$
    windowrulev2 = workspace 9 silent, title:^(Spotify)$

    # start Discord/WebCord in ws2
    windowrulev2 = workspace 2, title:^(.*(Disc|WebC)ord.*)$

    # idle inhibit while watching videos
    windowrulev2 = idleinhibit focus, class:^(mpv|.+exe)$
    windowrulev2 = idleinhibit focus, class:^(firefox)$, title:^(.*YouTube.*)$
    windowrulev2 = idleinhibit fullscreen, class:^(firefox)$

    windowrulev2 = dimaround, class:^(gcr-prompter)$

    # fix xwayland apps
    windowrulev2 = rounding 0, xwayland:1, floating:1
    windowrulev2 = center, class:^(.*jetbrains.*)$, title:^(Confirm Exit|Open Project|win424|win201|splash)$
    windowrulev2 = size 640 400, class:^(.*jetbrains.*)$, title:^(splash)$

    $layers = ^(eww-.+|bar|system-menu|anyrun|gtk-layer-shell)$
    layerrule = blur, $layers
    layerrule = ignorealpha 0, $layers
    layerrule = ignorealpha 0.5, ^(eww-music)$
    layerrule = ignorealpha 0${
      if variant == "dark"
      then ".5"
      else ""
    }, ^(eww-calendar|system-menu|anyrun)$
    layerrule = xray 1, ^(bar|gtk-layer-shell)$

    # mouse movements
    bindm = $mod, mouse:272, movewindow
    bindm = $mod, mouse:273, resizewindow
    bindm = $mod ALT, mouse:272, resizewindow

    # compositor commands
    bind = $mod SHIFT, E, exec, pkill Hyprland
    bind = $mod, Q, killactive,
    bind = $mod, F, fullscreen,
    bind = $mod, G, togglegroup,
    bind = $mod SHIFT, N, changegroupactive, f
    bind = $mod SHIFT, P, changegroupactive, b
    bind = $mod, R, togglesplit,
    bind = $mod, T, togglefloating,
    bind = $mod, P, pseudo,
    bind = $mod ALT, ,resizeactive,
    # toggle "monocle" (no_gaps_when_only)
    $kw = dwindle:no_gaps_when_only
    bind = $mod, M, exec, hyprctl keyword $kw $(($(hyprctl getoption $kw -j | jaq -r '.int') ^ 1))

    # utility
    # launcher
    bindr = $mod, SUPER_L, exec, pkill .${default.launcher}-wrapped || run-as-service ${default.launcher}
    # terminal
    bind = $mod, Return, exec, run-as-service ${default.terminal.name}
    # logout menu
    bind = $mod, Escape, exec, wlogout -p layer-shell
    # lock screen
    bind = $mod, L, exec, loginctl lock-session
    # select area to perform OCR on
    bind = $mod, O, exec, run-as-service wl-ocr

    # move focus
    bind = $mod, left, movefocus, l
    bind = $mod, right, movefocus, r
    bind = $mod, up, movefocus, u
    bind = $mod, down, movefocus, d

    # window resize
    bind = $mod, S, submap, resize

    submap = resize
    binde = , right, resizeactive, 10 0
    binde = , left, resizeactive, -10 0
    binde = , up, resizeactive, 0 -10
    binde = , down, resizeactive, 0 10
    bind = , escape, submap, reset
    submap = reset

    # media controls
    bindl = , XF86AudioPlay, exec, playerctl play-pause
    bindl = , XF86AudioPrev, exec, playerctl previous
    bindl = , XF86AudioNext, exec, playerctl next

    # volume
    bindle = , XF86AudioRaiseVolume, exec, wpctl set-volume -l "1.0" @DEFAULT_AUDIO_SINK@ 6%+
    binde = , XF86AudioRaiseVolume, exec, ${scriptDir}/volume osd
    bindle = , XF86AudioLowerVolume, exec, wpctl set-volume -l "1.0" @DEFAULT_AUDIO_SINK@ 6%-
    binde = , XF86AudioLowerVolume, exec, ${scriptDir}/volume osd
    bindl = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    bind = , XF86AudioMute, exec, ${scriptDir}/volume osd
    bindl = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

    # backlight
    bindle = , XF86MonBrightnessUp, exec, brillo -q -u 300000 -A 5
    binde = , XF86MonBrightnessUp, exec, ${scriptDir}/brightness osd
    bindle = , XF86MonBrightnessDown, exec, brillo -q -u 300000 -U 5
    binde = , XF86MonBrightnessDown, exec, ${scriptDir}/brightness osd

    # screenshot
    # stop animations while screenshotting; makes black border go away
    $screenshotarea = hyprctl keyword animation "fadeOut,0,0,default"; grimblast --notify copysave area; hyprctl keyword animation "fadeOut,1,4,default"
    bind = , Print, exec, $screenshotarea
    bind = $mod SHIFT, R, exec, $screenshotarea

    bind = CTRL, Print, exec, grimblast --notify --cursor copysave output
    bind = $mod SHIFT CTRL, R, exec, grimblast --notify --cursor copysave output

    bind = ALT, Print, exec, grimblast --notify --cursor copysave screen
    bind = $mod SHIFT ALT, R, exec, grimblast --notify --cursor copysave screen

    # workspaces
    # binds mod + [shift +] {1..10} to [move to] ws {1..10}
    ${builtins.concatStringsSep "\n" (builtins.genList (
        x: let
          ws = let
            c = (x + 1) / 10;
          in
            builtins.toString (x + 1 - (c * 10));
        in ''
          bind = $mod, ${ws}, workspace, ${toString (x + 1)}
          bind = $mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
        ''
      )
      10)}

    # special workspace
    bind = $mod SHIFT, grave, movetoworkspace, special
    bind = $mod, grave, togglespecialworkspace, eDP-1

    # cycle workspaces
    bind = $mod, bracketleft, workspace, m-1
    bind = $mod, bracketright, workspace, m+1

    # cycle monitors
    bind = $mod SHIFT, bracketleft, focusmonitor, l
    bind = $mod SHIFT, bracketright, focusmonitor, r
  '';
}
