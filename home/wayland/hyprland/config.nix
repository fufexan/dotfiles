{
  config,
  pkgs,
  colors,
  ...
}: let
  xargb = colors.xargbColors;
  config = ''
    # should be configured per-profile
    monitor=,1920x1080@144,0x0,1
    workspace=DP-1,1

    exec-once=systemctl --user start eww
    exec-once=swaybg -i ~/.config/wallpaper.jpg;
    exec-once=swayidle -w timeout 360 'swaylock' before-sleep 'swaylock'

    input {
        kb_layout=
        kb_variant=
        kb_model=
        kb_options=
        kb_rules=

        follow_mouse=1
        natural_scroll=0
    }

    general {
        sensitivity=1
        main_mod=SUPER

        gaps_in=5
        gaps_out=5
        border_size=2
        col.active_border=0x${xargb.base06}
        col.inactive_border=0x${xargb.base02}

        damage_tracking=monitor # experimental, monitor is 100% fine, but full might have some minor bugs, especially with high blur settings!
    }

    decoration {
        rounding=16
        blur=1
        blur_size=3 # minimum 1
        blur_passes=3 # minimum 1, more passes = more resource intensive.
        # Your blur "amount" is blur_size * blur_passes, but high blur_size (over around 5-ish) will produce artifacts.
        # if you want heavy blur, you need to up the blur_passes.
        # the more passes, the more you can up the blur_size without noticing artifacts.
    }

    animations {
        enabled=1
        animation=windows,1,2,default
        animation=borders,1,2,default
        animation=fadein,1,2,default
        animation=workspaces,1,2,default
    }

    dwindle {
        pseudotile=0 # enable pseudotiling on dwindle
    }

    # example window rules
    # for windows named/classed as abc and xyz
    #windowrule=move 69 420,abc
    #windowrule=size 420 69,abc
    #windowrule=tile,xyz
    #windowrule=float,abc
    #windowrule=pseudo,abc
    #windowrule=monitor 0,xyz

    # example binds
    bind=SUPER,RETURN,exec,alacritty
    bind=SUPER,Q,killactive,
    bind=SUPERSHIFT,E,exec,pkill Hyprland
    bind=SUPER,F,fullscreen,
    bind=SUPER,T,togglefloating,
    bind=SUPER,Space,exec,wofi --show drun --allow-images
    bind=SUPER,P,pseudo,
    bind=SUPER,L,exec,swaylock

    bind=,XF86AudioPlay,exec,playerctl play-pause
    bind=,XF86AudioPrev,exec,playerctl previous
    bind=,XF86AudioNext,exec,playerctl next
    bind=,XF86AudioLowerVolume,exec,pulsemixer --change-volume +6
    bind=,XF86AudioRaiseVolume,exec,pulsemixer --change-volume -6
    bind=,XF86AudioMute,exec,pulsemixer --mute

    bind=,XF86MonBrightnessUp,exec,light -A 5
    bind=,XF86MonBrightnessDown,exec,light -U 5

    # selection
    bind=,Print,exec,grim -g $(slurp -d) - | wl-copy -t image/png
    bind=SUPERSHIFT,R,exec,grim -g $(slurp -d) - | wl-copy -t image/png
    # fullscreen
    bind=CTRL,Print,exec,grim - | wl-copy -t image/png
    bind=SUPERSHIFTCTRL,R,exec,grim - | wl-copy -t image/png

    bind=SUPER,left,movefocus,l
    bind=SUPER,right,movefocus,r
    bind=SUPER,up,movefocus,u
    bind=SUPER,down,movefocus,d

    bind=SUPER,1,workspace,1
    bind=SUPER,2,workspace,2
    bind=SUPER,3,workspace,3
    bind=SUPER,4,workspace,4
    bind=SUPER,5,workspace,5
    bind=SUPER,6,workspace,6
    bind=SUPER,7,workspace,7
    bind=SUPER,8,workspace,8
    bind=SUPER,9,workspace,9
    bind=SUPER,0,workspace,10

    bind=SUPERSHIFT,1,movetoworkspace,1
    bind=SUPERSHIFT,2,movetoworkspace,2
    bind=SUPERSHIFT,3,movetoworkspace,3
    bind=SUPERSHIFT,4,movetoworkspace,4
    bind=SUPERSHIFT,5,movetoworkspace,5
    bind=SUPERSHIFT,6,movetoworkspace,6
    bind=SUPERSHIFT,7,movetoworkspace,7
    bind=SUPERSHIFT,8,movetoworkspace,8
    bind=SUPERSHIFT,9,movetoworkspace,9
    bind=SUPERSHIFT,0,movetoworkspace,10
  '';
in
  config
