{ config, ... }:

# manage home.files

let
  home = config.home.homeDirectory;
in
{
  # font for rofi applets
  home.file.featherfont = {
    source = ../config/fonts/feather.ttf;
    target = "${home}/.local/share/fonts/feather.ttf";
  };
  # directory of different layouts for rofi applets
  home.file.rofiLayouts = {
    source = ../config/rofi/layouts;
    target = "${home}/.local/share/rofi/layouts";
  };

  # config files
  home.file."flameshot.ini" = {
    source = ../config/flameshot.ini;
    target = "${home}/.config/flameshot/flameshot.ini";
  };
  home.file.rangerrc = {
    source = ../config/ranger.rc.conf;
    target = "${home}/.config/ranger/rc.conf";
  };
  home.file.youtube-dl = {
    source = ../config/youtube-dl.conf;
    target = "${home}/.config/youtube-dl/config";
  };
  
  # scripts
  # script to dynamically modify bspwm borders and gaps
  home.file.dynamic_bspwm = {
    source = ../scripts/dynamic_bspwm.sh;
    target = "${home}/.local/bin/dynamic_bspwm.sh";
  };
  # script to screenshot the monitor which contains the mouse
  home.file.maim_monitor = {
    source = ../scripts/maim_monitor.sh;
    target = "${home}/.local/bin/maim_monitor.sh";
  };
  # rofi applets scripts
  home.file.rofiScripts = {
    source = ../scripts/rofi;
    target = "${home}/.local/bin/rofi";
  };
}
