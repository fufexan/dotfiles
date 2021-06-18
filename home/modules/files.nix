# manage files in ~

{
  home.file = {
    # font for rofi applets
    ".local/share/fonts".source = ../config/fonts;

    # directory of different layouts for rofi applets
    ".local/share/rofi/layouts".source = ../config/rofi/layouts;

    # config files
    ".config/ranger".source = ../config/ranger;
    ".config/youtube-dl".source = ../config/youtube-dl;

    # script to dynamically modify bspwm borders and gaps
    ".local/bin/dynamic_bspwm.sh".source = ../scripts/dynamic_bspwm.sh;

    # script to screenshot the monitor which contains the mouse
    ".local/bin/screenshot.sh".source = ../scripts/screenshot.sh;
  };
}
