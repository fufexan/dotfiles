{ config, pkgs, colors, ... }:

# most of X configuration

let
  inherit (colors) x fg bg normal bright;
in
{
  imports = [
    #./autorandr.nix
    ./dunst.nix
    ./picom.nix
    ./polybar
    ./rofi
    ./sxhkd.nix
  ];

  # X specific programs
  home.packages = with pkgs; [
    dunst # for dunstctl
    maim
    xclip
    xdotool
    xorg.xkill
    xdragon # file drag n drop
  ];

  programs.feh.enable = true;

  services = {
    flameshot.enable = true;

    random-background = {
      enable = true;
      imageDirectory = "${config.home.homeDirectory}/Pictures/wallpapers/summer/dark";
    };

    redshift = {
      enable = true;
      provider = "geoclue2";
    };
  };

  # manage X session
  xsession = {
    enable = true;
    # to be able to use system-configured sessions alongside HM ones
    scriptPath = ".xsession-hm";

    pointerCursor = {
      package = pkgs.quintom-cursor-theme;
      name = "Quintom_Ink";
      size = 24;
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
          #elif [ $(bspc config window_gap) -gt 0 ]; then
          else
            bspc query -N -d $Desktop | while read -r Node
            do
              xprop -id $Node -remove _PICOM_ROUNDED
            done
          fi
        done &
      '';

      rules = {
        "Firefox" = { desktop = "^1"; };
        "Emacs" = { desktop = "^2"; };
        "osu!.exe" = { desktop = "^3"; };
        "discord" = { desktop = "^6"; };
        "TelegramDesktop" = { desktop = "^7"; };
        "Element" = { desktop = "^8"; };
      };

      settings = {
        border_width = 2;
        window_gap = 8;

        active_border_color = x normal.red;
        focused_border_color = x normal.black;
        normal_border_color = x normal.yellow;
        presel_feedback_color = x normal.green;

        split_ratio = 0.5;
        borderless_monocle = true;
        gapless_monocle = true;
        single_monocle = true;
      };

      startupPrograms = [
        # sets proper monitor layout, then focuses first desktop
        #"autorandr -c && bspc desktop -f ^1"
        "systemctl --user restart polybar"
      ];
    };
  };

  xresources.properties = {
    #! special
    "*.foreground" = x fg;
    "*.background" = x bg;

    # black
    "*.color0" = x normal.black;
    "*.color8" = x bright.black;
    # red
    "*.color1" = x normal.red;
    "*.color9" = x bright.red;
    # green
    "*.color2" = x normal.green;
    "*.color10" = x bright.green;
    # yellow
    "*.color3" = x normal.yellow;
    "*.color11" = x bright.yellow;
    # blue
    "*.color4" = x normal.blue;
    "*.color12" = x bright.blue;
    # magenta
    "*.color5" = x normal.magenta;
    "*.color13" = x bright.magenta;
    # cyan
    "*.color6" = x normal.cyan;
    "*.color14" = x bright.cyan;
    # white
    "*.color7" = x normal.white;
    "*.color15" = x bright.white;
  };
}
