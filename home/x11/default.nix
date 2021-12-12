{ config, pkgs, nix-colors, self, ... }:

# most of X configuration

let
  inherit (self.lib) mapAttrs x;
  colors = mapAttrs (n: v: x v) nix-colors.colors;
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

        active_border_color = colors.base08;
        focused_border_color = colors.base02;
        normal_border_color = colors.base0A;
        presel_feedback_color = colors.base0B;

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
    "*.foreground" = colors.base06;
    "*.background" = colors.base00;

    # black
    "*.color0" = colors.base02;
    "*.color8" = colors.base03;
    # red
    "*.color1" = colors.base08;
    "*.color9" = colors.base08;
    # green
    "*.color2" = colors.base0B;
    "*.color10" = colors.base0B;
    # yellow
    "*.color3" = colors.base0A;
    "*.color11" = colors.base0A;
    # blue
    "*.color4" = colors.base0D;
    "*.color12" = colors.base0D;
    # magenta
    "*.color5" = colors.base0E;
    "*.color13" = colors.base0E;
    # cyan
    "*.color6" = colors.base0C;
    "*.color14" = colors.base0C;
    # white
    "*.color7" = colors.base06;
    "*.color15" = colors.base07;
  };
}
