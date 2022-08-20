{
  pkgs,
  colors,
  default,
  ...
}: let
  xargb = colors.xargbColors;

  emoji = "${pkgs.wofi-emoji}/bin/wofi-emoji";
  launcher = pkgs.writeShellScript "launcher" "${pkgs.wofi}/bin/wofi --show drun,run -t ${term}";
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
    monitor=eDP-1,preferred,auto,1.6
    workspace=eDP-1,1
    monitor=DP-1,preferred,auto,1
    workspace=DP-1,10
    monitor=DP-2,preferred,auto,1
    workspace=DP-2,10

    exec-once=swaybg -i ~/.config/wallpaper.jpg

    misc {
      no_vfr=0
    }

    gestures {
      workspace_swipe=1
    }

    input {
      kb_layout=ro
      sensitivity=0

      follow_mouse=1
      force_no_accel=1

      touchpad {
        natural_scroll=1
      }
    }

    general {
      sensitivity=0.6
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
      animation=fade,1,2,default
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

    bind=SUPER,Return,exec,${run-as-service "manual"} ${term}
    bind=SUPER,Space,exec,${run-as-service "manual"} ${launcher}
    bind=SUPER,Escape,exec,wlogout -p layer-shell
    bind=SUPER,E,exec,${emoji}
    bind=SUPER,Q,killactive,
    bind=SUPERSHIFT,E,exec,pkill Hyprland
    bind=SUPER,F,fullscreen,
    bind=SUPER,R,togglesplit,
    bind=SUPER,T,togglefloating,
    bind=SUPER,P,pseudo,
    bind=SUPER,L,exec,swaylock
    bind=SUPER,O,exec,wl-ocr

    bind=,XF86AudioPlay,exec,playerctl play-pause
    bind=,XF86AudioPrev,exec,playerctl previous
    bind=,XF86AudioNext,exec,playerctl next
    bind=,XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%+
    bind=,XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%-
    bind=,XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    bind=,XF86AudioMicMute,exec,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

    bind=,XF86MonBrightnessUp,exec,light -A 5
    bind=,XF86MonBrightnessDown,exec,light -U 5

    # screenshot

    bind=,Print,exec,screenshot area
    bind=SUPERSHIFT,R,exec,screenshot area

    # monitor
    bind=CTRL,Print,exec,screenshot monitor
    bind=SUPERSHIFTCTRL,R,exec,screenshot monitor

    # all-monitors
    bind=ALT,Print,exec,screenshot all
    bind=SUPERSHIFTALT,R,exec,screenshot all

    # screenrec
    # bind=ALT,Print,exec,screenshot rec area
    # bind=SUPERSHIFTALT,R,exec,screenshot rec area

    # move focus
    bind=SUPER,left,movefocus,l
    bind=SUPER,right,movefocus,r
    bind=SUPER,up,movefocus,u
    bind=SUPER,down,movefocus,d

    ${builtins.concatStringsSep "\n" (builtins.genList (
        x: let
          ws = let
            c = (x + 1) / 10;
          in
            builtins.toString (x + 1 - (c * 10));
          shiftedNumbers = ["exclam" "at" "numbersign" "dollar" "percent" "asciicircum" "ampersand" "asterisk" "parenleft" "parenright"];
        in ''
          bind=SUPER,${ws},workspace,${toString (x + 1)}
          bind=SHIFTSUPER,${builtins.elemAt shiftedNumbers x},movetoworkspace,${builtins.toString (x + 1)}
        ''
      )
      10)}

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
