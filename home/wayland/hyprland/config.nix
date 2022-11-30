{
  pkgs,
  colors,
  default,
  ...
}: let
  xargb = colors.xargbColors;

  emoji = "${pkgs.wofi-emoji}/bin/wofi-emoji";
  launcher = "wofi";

  # runs processes as systemd transient services
  run-as-service = slice:
    pkgs.writeShellScript "as-systemd-transient" ''
      exec ${pkgs.systemd}/bin/systemd-run \
        --slice=app-${slice}.slice \
        --property=ExitType=cgroup \
        --user \
        --wait \
        bash -lc "exec apply-hm-env $@"
    '';
in ''
  $mod = SUPER

  # should be configured per-profile
  monitor = DP-1, preferred, auto, 1
  monitor = DP-2, preferred, auto, 1
  monitor = eDP-1, preferred, auto, 2
  workspace = eDP-1, 1
  workspace = DP-1, 10
  workspace = DP-2, 10

  # scale apps
  exec-once = xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2

  exec-once = systemctl --user start clight
  exec-once = eww open bar

  misc {
    # enable Variable Frame Rate
    no_vfr = 0
  }

  # touchpad gestures
  gestures {
    workspace_swipe = 1
    workspace_swipe_forever = 1
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
    natural_scroll = 1
  }

  general {
    gaps_in = 5
    gaps_out = 5
    border_size = 2
    col.active_border = 0x${xargb.base06} # white
    col.inactive_border = 0x${xargb.base02} # black
  }

  decoration {
    rounding = 16
    blur = 1
    blur_size = 3
    blur_passes = 3
    blur_new_optimizations = 1

    drop_shadow = 1
    shadow_ignore_window = 1
    shadow_offset = 2 2
    shadow_range = 4
    shadow_render_power = 1
    col.shadow = 0x55000000
  }

  animations {
    enabled = 1
    animation = border, 1, 2, default
    animation = fade, 1, 4, default
    animation = windows, 1, 3, default, popin 80%
    animation = workspaces, 1, 2, default, slide
  }

  dwindle {
    # keep floating dimentions while tiling
    pseudotile = 1
    preserve_split = 1
    # aka monocle mode
    no_gaps_when_only = 1
  }

  # telegram media viewer
  windowrulev2 = float, title:^(Media viewer)$

  # make Firefox PiP window floating and sticky
  windowrulev2 = float, title:^(Picture-in-Picture)$
  windowrulev2 = pin, title:^(Picture-in-Picture)$

  # throw sharing indicators away
  windowrulev2 = workspace special silent, title:^(Firefox — Sharing Indicator)$
  windowrulev2 = workspace special silent, title:^(.*is sharing (your screen|a window)\.)$

  # start spotify tiled in ws9
  windowrulev2 = tile, class:^(Spotify)$
  windowrulev2 = workspace 9 silent, class:^(Spotify)$

  # start Discord/WebCord in ws2
  windowrulev2 = workspace 2, title:^(.*Discord.*)$
  windowrulev2 = workspace 2, title:^(WebCord)$

  # idle inhibit while watching videos
  windowrulev2 = idleinhibit focus, class:^(mpv)$
  windowrulev2 = idleinhibit fullscreen, class:^(firefox)$

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

  # utility
  # launcher
  bindr = $mod, SUPER_L, exec, pkill .${launcher}-wrapped || ${run-as-service "manual"} ${launcher}
  # terminal
  bind = $mod, Return, exec, ${run-as-service "manual"} ${default.terminal.name}
  # logout menu
  bind = $mod, Escape, exec, wlogout -p layer-shell
  # lock screen
  bind = $mod, L, exec, swaylock
  # emoji picker
  bind = $mod, E, exec, ${emoji}
  # select area to perform OCR on
  bind = $mod, O, exec, wl-ocr

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
  bindle = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%+
  bindle = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%-
  bindl = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
  bindl = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

  # backlight
  bindle = , XF86MonBrightnessUp, exec, light -A 5
  bindle = , XF86MonBrightnessDown, exec, light -U 5

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
  bind = $mod SHIFT, braceleft, focusmonitor, l
  bind = $mod SHIFT, braceright, focusmonitor, r
''
