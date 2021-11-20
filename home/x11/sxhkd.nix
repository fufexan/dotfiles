{ config, pkgs, ... }:

let
  # user scripts
  s = "~/.local/bin";
in
{
  services.sxhkd = {
    enable = true;
    keybindings = {
      # general

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
      "super + {t,shift + t,s,f}" = "bspc node -t {tiled,pseudo_tiled,floating,fullscreen}";
      # set the node flags
      "super + ctrl + {m,x,y,z}" = "bspc node -g {marked,locked,sticky,private}";

      # focus/swap

      # focus the node in the given direction
      "super + {_,shift + }{h,j,k,l}" = "bspc node -{f,s} {west,south,north,east}";
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
      "super + ctrl + shift + space" = "bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel";

      # move/resize

      # expand a window by moving one of its side outward
      "super + alt + {h,j,k,l}" = "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";
      # contract a window by moving one of its side inward
      "super + alt + shift + {h,j,k,l}" = "bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";
      # move a floating window
      "super + {Left,Down,Up,Right}" = "bspc node -v {-20 0,0 20,0 -20,20 0}";
      # rotate window layout clockwise 90 degrees
      "super + r" = "bspc node @parent -R 90";
      # increase/decrease borders
      "super + {_,ctrl + } {equal,minus}" = "${s}/dynamic_bspwm {b,g} {+,-}";

      # programs

      # screenshot selection
      "Print" = "flameshot gui";
      # screencast region
      "alt + Print" = "${s}/scrrec -s ~/Videos/scrrec/$(date +%F-%T).mp4";
      # powermenu
      "super + p" = "${s}/powermenu";
      # emoji launcher
      "super + e" = "rofi -show emoji";
      # rofi pass
      "super + i" = "rofi-pass";
      # window switcher
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

      # backlight

      "XF86BrightnessMon{Up,Down}" = "light -{A,U} 5";
    };
  };
}
