{ config, pkgs, ... }:

# most of X configuration

let
  edids = {
    DVI-D-0 =
      "00ffffffffffff00410cafc06d37000005170103802917782abe05a156529d270c5054bd4b00818081c0010101010101010101010101662156aa51001e30468f33009ae61000001e000000ff00554b3031333035303134313839000000fc005068696c697073203139365634000000fd00384c1e530e000a20202020202000ba";
    HDMI-0 =
      "00ffffffffffff0009d1ea78455400000b1e010380301b782eb065a656539d280c5054a56b80d1c081c081008180a9c0b30001010101023a801871382d40582c4500dc0c1100001e000000ff0045334c30373535303031390a20000000fd00324c1e5311000a202020202020000000fc0042656e5120424c323238330a200193020322f14f901f05140413031207161501061102230907078301000065030c001000023a801871382d40582c4500dc0c1100001e011d8018711c1620582c2500dc0c1100009e011d007251d01e206e285500dc0c1100001e8c0ad08a20e02d10103e9600dc0c1100001800000000000000000000000000000000000000000081";
  };
in {
  # X specific programs
  home.packages = with pkgs; [
    maim
    xclip
    xdotool
    xorg.xkill
    xdragon # file drag n drop
  ];

  # programs
  # manage monitor configurations
  programs.autorandr = {
    enable = true;
    profiles.home = {
      fingerprint = edids;
      config = {
        HDMI-0 = {
          enable = true;
          crtc = 1;
          gamma = "1.099:1.0:0.909";
          mode = "1920x1080";
          position = "0x0";
          rate = "60.00";
          primary = true;
        };
        DVI-D-0 = {
          enable = true;
          crtc = 0;
          gamma = "1.099:1.0:0.909";
          mode = "1366x768";
          position = "1920x312";
          rate = "60.00";
        };
      };
      hooks.postswitch = "systemctl --user restart random-background polybar";
    };
    profiles.hdmi = {
      fingerprint = edids;
      config = {
        HDMI-0 = {
          enable = true;
          crtc = 1;
          gamma = "1.099:1.0:0.909";
          mode = "1920x1080";
          position = "0x0";
          rate = "60.00";
          primary = true;
        };
        DVI-D-0.enable = false;
      };
      hooks.postswitch = "systemctl --user restart random-background polybar";
    };
    profiles.osu = {
      fingerprint = edids;
      config = {
        HDMI-0 = {
          enable = true;
          crtc = 1;
          gamma = "1.099:1.0:0.909";
          mode = "1280x1024";
          position = "0x0";
          rate = "75.00";
          primary = true;
        };
      };
    };
  };
  programs.feh.enable = true;
  programs.rofi = {
    enable = true;
    package = pkgs.rofi.override { plugins = [ pkgs.rofi-emoji ]; };
    theme = ../config/rofi/general.rasi;
  };
  programs.rofi.pass = {
    enable = true;
    extraConfig = ''
      URL_field='url';
      USERNAME_field='user';
    '';
    stores = [ "$HOME/.local/share/password-store" ];
  };

  # notification daemon
  services.caffeine.enable = true;
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    settings = {
      global = {
        alignment = "center";
        corner_radius = 10;
        follow = "mouse";
        font = "Noto Sans 10";
        format = "<b>%s</b>\\n%b";
        frame_width = 2;
        geometry = "400x5-4+32";
        horizontal_padding = 8;
        icon_position = "left";
        indicate_hidden = "yes";
        markup = "yes";
        max_icon_size = 96;
        mouse_left_click = "do_action";
        mouse_middle_click = "close_all";
        mouse_right_click = "close_current";
        padding = 8;
        plain_text = "no";
        separator_color = "auto";
        separator_height = 1;
        show_indicators = false;
        shrink = "no";
        word_wrap = "yes";
      };
      fullscreen_delay_everything = { fullscreen = "delay"; };
      urgency_critical = {
        background = "#16161c";
        foreground = "#fdf0ed";
        frame_color = "#e95678";
      };
      urgency_low = {
        background = "#16161c";
        foreground = "#fdf0ed";
        frame_color = "#29d398";
      };
      urgency_normal = {
        background = "#16161c";
        foreground = "#fdf0ed";
        frame_color = "#fab795";
      };
    };
  };
  services.picom = {
    enable = true;
    blur = true;
    blurExclude = [ "class_g = 'slop'" "class_g = 'Firefox'" ];
    experimentalBackends = true;
    extraOptions = ''
      #################################
      #          Animations           #
      #################################
      # requires https://github.com/jonaburg/picom
      # (These are also the default values)
      #transition-length = 100
      transition-pow-x = 1.4 #0.2
      transition-pow-y = 1.4 #0.2
      transition-pow-w = 1.4 #0.2
      transition-pow-h = 1.4 #0.2
      size-transition = true


      #################################
      #             Corners           #
      #################################
      # requires: https://github.com/sdhand/compton or https://github.com/jonaburg/picom
      corner-radius = 10.0;
      rounded-corners-exclude = [
        "class_g = 'Polybar'",
        "class_g = 'Steam'",
        "_PICOM_ROUNDED:32c = 1",
      ];
      round-borders = 1;
      round-borders-exclude = [
        #"class_g = 'TelegramDesktop'",
      ];

      fading = true;
      fade-delta = 5

      # Specify a list of conditions of windows that should not be faded.
      # don't need this, we disable fading for all normal windows with wintypes: {}
      fade-exclude = [
        "class_g = 'slop'" # maim
      ]

      # improve performance
      glx-no-rebind-pixmap = true;

      glx-no-stencil = true;

      # fastest swap method
      glx-swap-method = 1;

      # dual kawase blur
      blur-background-fixed = false;
      blur-method = "dual_kawase";
      blur-strength = 10;

      use-ewmh-active-win = true;
      detect-rounded-corners = true;

      # stop compositing if there's a fullscreen program
      unredir-if-possible = true;

      # group wintypes and don't focus a menu (Telegram)
      detect-transient = true;
      detect-client-leader = true;

      # needed for nvidia with glx backend
      xrender-sync-fence = true;
    '';
  };
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      mpdSupport = true;
      pulseSupport = true;
    };
    config = ../config/polybar/config;
    script = ''
      polybar main &
      polybar external &
    '';
  };
  services.random-background = {
    enable = true;
    imageDirectory =
      "${config.home.homeDirectory}/Pictures/wallpapers/artworks";
  };
  services.redshift = {
    enable = true;
    provider = "geoclue2";
  };
  services.sxhkd = {
    enable = true;
    keybindings = 
    let
      # user scripts
      s = "~/.local/bin";
      rs = "${s}/rofi";
    in {
      # start terminal
      "super + Return" = "alacritty";
      # application launcher
      "super + @space" = "rofi -show combi";
      # reload sxhkd
      "super + Escape" = "pkill -USR1 -x sxhkd";
      # pause/resume notifications
      "super + ctrl + Escape" = "dunstctl set-paused toggle";
      # bspwm hotkeys
      # quit bspwm normally
      "super + alt + Escape" = "bspc quit";
      # close/kill
      "super + {_,shift + }q" = "bspc node -{c,k}";
      # monocle layout
      "super + m" = "bspc desktop -l next";
      # send the newest marked node to the newest preselected node
      "super + y" = "bspc node newest.marked.local -n newest.!automatic.local";
      # swap the current node and the biggest node
      "super + g" = "bspc node -s biggest";
      # state/flags
      # set the window state
      "super + {t,shift + t,s,f}" =
        "bspc node -t {tiled,pseudo_tiled,floating,fullscreen}";
      # set the node flags
      "super + ctrl + {m,x,y,z}" =
        "bspc node -g {marked,locked,sticky,private}";
      # focus/swap
      # focus the node in the given direction
      "super + {_,shift + }{h,j,k,l}" =
        "bspc node -{f,s} {west,south,north,east}";
      # focus the next/previous node in the current desktop
      "super + {_,shift + }c" = "bspc node -f {next,prev}.local";
      # focus the next/previous desktop in the current monitor
      "super + bracket{left,right}" = "bspc desktop -f {prev,next}.local";
      # focus the last node/desktop
      "super + {grave,Tab}" = "bspc {node,desktop} -f last";
      # focus or send to the given desktop
      "super + {_,shift + }{1-9,0}" = "bspc {desktop -f,node -d} '^{1-9,10}'";
      # preselect the direction
      "super + ctrl + {h,j,k,l}" = "bspc node -p {west,south,north,east}";
      # preselect the ratio
      "super + ctrl + {1-9}" = "bspc node -o 0.{1-9}";
      # cancel the preselection for the focused node
      "super + ctrl + space" = "bspc node -p cancel";
      # cancel the preselection for the focused desktop
      "super + ctrl + shift + space" =
        "bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel";
      # move/resize
      # expand a window by moving one of its side outward
      "super + alt + {h,j,k,l}" =
        "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";
      # contract a window by moving one of its side inward
      "super + alt + shift + {h,j,k,l}" =
        "bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";
      # move a floating window
      "super + {Left,Down,Up,Right}" = "bspc node -v {-20 0,0 20,0 -20,20 0}";
      # rotate window layout clockwise 90 degrees
      "super + r" = "bspc node @parent -R 90";
      # increase/decrease borders
      "super + {_, ctrl + } {equal,minus}" =
        "${s}/dynamic_bspwm.sh {b,g} {+,-}";
      #	programs
      # screenshot selection
      "{_,super + ,super + ctrl + }Print" = "${s}/screenshot.sh {area,screen,rofi}";
      # screencast region
      "alt + Print" =
        "${s}/scrrec -s ~/Videos/scrrec/$(date +%F-%T).mp4";
      # backlight menu
      "super + b" = "${rs}/backlight.sh";
      # powermenu
      "super + p" = "${rs}/powermenu.sh";
      # volume menu
      "super + v" = "${rs}/volume.sh";
      # mpd menu
      "super + shift + m" = "${rs}/mpd.sh";
      # emoji launcher
      "super + e" = "rofi -show emoji";
      # rofi pass
      "super + i" = "rofi-pass";
      # window switchere
      "alt + Tab" = "rofi -show window";
      # audio controls
      # play/pause
      "{Pause,XF86AudioPlay}" = "playerctl play-pause";
      # next/prev song
      "super + shift + {Right,Left}" = "playerctl {next,previous}";
      # toggle repeat/shuffle
      "super + alt + {r,z}" = "playerctl {loop,shuffle}";
      # volume up/down
      "XF86Audio{Raise,Lower}Volume" = "pulsemixer --change-volume {+,-}5";
      # toggle mute
      "XF86AudioMute" = "pulsemixer --toggle-mute";
    };
  };

  # manage X session
  xsession = {
    enable = true;
    pointerCursor = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = 16;
    };
    preferStatusNotifierItems = true;
    windowManager.bspwm = {
      enable = true;
      extraConfig = ''
        bspc subscribe desktop_layout | while read -r Event
        do
          Desktop=$(echo "$Event" | awk '{print $3}')
          State=$(echo "$Event" | awk '{print $4}')
          if [ "$State" = "monocle" ]; then 
            bspc query -N -d $Desktop | while read -r Node
            do
              xprop -id $Node -f _PICOM_ROUNDED 32c -set _PICOM_ROUNDED 1
            done
          elif [ $(bspc config window_gap) -gt 0 ]; then
            bspc query -N -d $Desktop | while read -r Node
            do
              xprop -id $Node -remove _PICOM_ROUNDED
            done
          fi
        done &
      '';
      monitors = {
        HDMI-0 = [ "一" "二" "三" "四" "五" ];
        DVI-D-0 = [ "六" "七" "八" "九" "十" ];
      };
      settings = {
        border_width = 2;
        window_gap = 8;

        active_border_color = "#e95678";
        focused_border_color = "#16161c";
        normal_border_color = "#fab795";
        presel_feedback_color = "#29d398";

        split_ratio = 0.5;
        borderless_monocle = true;
        gapless_monocle = true;
        single_monocle = true;
      };
      startupPrograms = [
        # sets proper monitor layout, then focuses first desktop
        "autorandr -c && bspc desktop -f 1"
      ];
    };
  };
}
