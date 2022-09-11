{
  pkgs,
  colors,
  default,
  ...
}: let
  xargb = colors.xargbColors;

  emoji = "${pkgs.wofi-emoji}/bin/wofi-emoji";
  launcher = "wofi";
  term = default.terminal.name;

  run-as-service = slice:
    pkgs.writeShellScript "as-systemd-transient" ''
      exec ${pkgs.systemd}/bin/systemd-run \
        --slice=app-${slice}.slice \
        --property=ExitType=cgroup \
        --user \
        --wait \
        bash -lc "exec apply-hm-env $@"
    '';

  config = ''
    # should be configured per-profile
    monitor=DP-1,preferred,auto,1
    monitor=DP-2,preferred,auto,1
    monitor=eDP-1,preferred,auto,1.6
    workspace=eDP-1,1
    workspace=DP-1,10
    workspace=DP-2,10

    exec-once=xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2
    exec-once=swaybg -i ~/.config/wallpaper.png
    exec-once=swayidle \
      timeout 300 "hyprctl dispatch dpms off" \
      resume "hyprctl dispatch dpms on" \
      timeout 310 "loginctl lock-session" \
      timeout 600 "systemctl suspend" \
      before-sleep swaylock \
      lock swaylock
    exec-once=eww daemon
    exec-once=eww open bar

    misc {
      no_vfr=0
    }

    gestures {
      workspace_swipe=1
    }

    input {
      kb_layout=ro

      follow_mouse=1
      force_no_accel=1
    }

    device:MSFT0001:00 04F3:31EB Touchpad {
      # sensitivity=-1
      natural_scroll=1
    }

    general {
      main_mod=SUPER

      gaps_in=5
      gaps_out=5
      border_size=2
      col.active_border=0x${xargb.base06}
      col.inactive_border=0x${xargb.base02}
    }

    decoration {
      rounding=16
      blur=1
      blur_size=3
      blur_passes=3
      blur_new_optimizations=1

      drop_shadow=1
      shadow_ignore_window=1
      shadow_offset=2 2
      shadow_range=4
      shadow_render_power=1
      col.shadow=0x55000000
    }

    animations {
      enabled=1
      animation=border,1,2,default
      animation=fade,1,4,default
      animation=windows,1,3,default,popin 80%
      animation=workspaces,1,2,default,slide
    }

    dwindle {
      pseudotile=1
      preserve_split=1
    }

    windowrule=float,title:^(Media viewer)$
    windowrule=float,title:^(Picture-in-Picture)$
    windowrule=float,title:^(Firefox — Sharing Indicator)$
    windowrule=move 0 0,title:^(Firefox — Sharing Indicator)$

    windowrule=tile,title:^(Spotify)$
    windowrule=workspace 9,title:^(Spotify)$
    windowrule=workspace 2,title:^(Discord)$

    # compositor commands
    bind=SUPERSHIFT,E,exec,pkill Hyprland
    bind=SUPER,Q,killactive,
    bind=SUPER,F,fullscreen,
    bind=SUPER,G,togglegroup,
    bind=SUPERSHIFT,N,changegroupactive,f
    bind=SUPERSHIFT,P,changegroupactive,b
    bind=SUPER,R,togglesplit,
    bind=SUPER,T,togglefloating,
    bind=SUPER,P,pseudo,
    bind=SUPERALT,,resizeactive,

    # utility
    bind=SUPER,Return,exec,${run-as-service "manual"} ${term}
    bind=SUPER,Space,exec,${run-as-service "manual"} ${launcher}
    bind=SUPER,Escape,exec,wlogout -p layer-shell
    bind=SUPER,L,exec,swaylock
    bind=SUPER,E,exec,${emoji}
    bind=SUPER,O,exec,wl-ocr
    # move focus
    bind=SUPER,left,movefocus,l
    bind=SUPER,right,movefocus,r
    bind=SUPER,up,movefocus,u
    bind=SUPER,down,movefocus,d

    # media controls
    bind=,XF86AudioPlay,exec,playerctl play-pause
    bind=,XF86AudioPrev,exec,playerctl previous
    bind=,XF86AudioNext,exec,playerctl next

    # volume
    bindle=,XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%+
    bindle=,XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%-
    bind=,XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    bind=,XF86AudioMicMute,exec,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

    # backlight
    bindle=,XF86MonBrightnessUp,exec,light -A 5
    bindle=,XF86MonBrightnessDown,exec,light -U 5

    # screenshot
    bind=,Print,exec,grimblast --notify copysave area
    bind=SUPERSHIFT,R,exec,grimblast --notify copysave area
    bind=CTRL,Print,exec,grimblast --notify --cursor copysave output
    bind=SUPERSHIFTCTRL,R,exec,grimblast --notify --cursor copysave output
    bind=ALT,Print,exec,grimblast --notify --cursor copysave screen
    bind=SUPERSHIFTALT,R,exec,grimblast --notify --cursor copysave screen

    # workspaces
    ${builtins.concatStringsSep "\n" (builtins.genList (
        x: let
          ws = let
            c = (x + 1) / 10;
          in
            builtins.toString (x + 1 - (c * 10));
        in ''
          bind=SUPER,${ws},workspace,${toString (x + 1)}
          bind=SHIFTSUPER,${ws},movetoworkspacesilent,${toString (x + 1)}
        ''
      )
      10)}

    # special workspace
    bind=SUPERSHIFT,asciitilde,movetoworkspace,special
    bind=SUPER,grave,togglespecialworkspace,eDP-1

    # cycle workspaces
    bind=SUPER,bracketleft,workspace,m-1
    bind=SUPER,bracketright,workspace,m+1
    # cycle monitors
    bind=SUPERSHIFT,braceleft,focusmonitor,l
    bind=SUPERSHIFT,braceright,focusmonitor,r
  '';
in
  config
