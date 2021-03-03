{ config, ... }:

# manage home.files

{
  # font for rofi applets
  home.file.featherfont = {
    source = ./config/fonts/feather.ttf;
    target = "${config.home.homeDirectory}/.local/share/fonts/feather.ttf";
  };
  # flameshot config file (maybe it should be included in services.flameshot)
  home.file."flameshot.ini" = {
    source = ./config/flameshot.ini;
    target = "${config.home.homeDirectory}/.config/flameshot/flameshot.ini";
  };
  # script to dynamically modify bspwm borders and gaps
  home.file.dynamic_bspwm = {
    source = ./scripts/dynamic_bspwm.sh;
    target = "${config.home.homeDirectory}/.local/bin/dynamic_bspwm.sh"
  };
  # script to screenshot the monitor which contains the mouse
  home.file.maim_monitor = {
    source = ./scripts/maim_monitor.sh;
    target = "${config.home.homeDirectory}/.local/bin/maim_monitor.sh";
  };
  # directory of different layouts for rofi applets
  home.file.rofiLayouts = {
    source = ./config/rofi/layouts;
    target = "${config.home.homeDirectory}/.local/share/rofi/layouts";
  };
  # rofi applets scripts
  home.file.rofiScripts = {
    source = ./scripts/rofi;
    target = "${config.home.homeDirectory}/.local/bin/rofi";
  };
}
