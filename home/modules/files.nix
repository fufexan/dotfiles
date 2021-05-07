{ config, ... }:

# manage home.files

let home = config.home.homeDirectory;
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
  home.file.ranger = {
    source = ../config/ranger/rc.conf;
    target = "${home}/.config/ranger/rc.conf";
  };
  home.file.rangerdevicons_init = {
    source = ../config/ranger/devicons/__init__.py;
    target = "${home}/.config/ranger/plugins/devicons/__init__.py";
  };
  home.file.rangerdevicons = {
    source = ../config/ranger/devicons/devicons.py;
    target = "${home}/.config/ranger/plugins/devicons/devicons.py";
  };
  home.file.youtube-dl = {
    source = ../config/youtube-dl/conf;
    target = "${home}/.config/youtube-dl/conf";
  };

  # scripts
  # script to dynamically modify bspwm borders and gaps
  home.file.dynamic_bspwm = {
    source = ../scripts/dynamic_bspwm.sh;
    target = "${home}/.local/bin/dynamic_bspwm.sh";
  };
  # script to screenshot the monitor which contains the mouse
  home.file.maim_monitor = {
    source = ../scripts/screenshot.sh;
    target = "${home}/.local/bin/screenshot.sh";
  };
  # rofi applets scripts
  home.file.rofiScripts = {
    source = ../scripts/rofi;
    target = "${home}/.local/bin/rofi";
  };
  # screen recording
  home.file.scrrec = {
    source = ../scripts/scrrec;
    target = "${home}/.local/bin/scrrec";
  };
  # mp4 to gif
  home.file.mov2gif = {
    source = ../scripts/mov2gif;
    target = "${home}/.local/bin/mov2gif";
  };
}
