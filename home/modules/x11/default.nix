{ config, pkgs, ... }:

# most of X configuration

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

      monitors = {
        HDMI-0 = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
        LVDS-1 = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
      };

      rules = {
        "Firefox" = { desktop = "^1"; };
        "osu!.exe" = { desktop = "^3"; };
        "discord" = { desktop = "^6"; };
        "TelegramDesktop" = { desktop = "^7"; };
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
        #"autorandr -c && bspc desktop -f ^1"
        "systemctl --user restart polybar"
      ];
    };
  };
}
