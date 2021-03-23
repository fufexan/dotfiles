{ config, ... }:

{
  programs.mako.enable = true;
  
  wayland.windowManager.sway = {
    enable = true;
    config.keybindings = let mod = config.wayland.windowManager.sway.config.modifier; in {
      "${mod}+Return" = "exec alacritty";
      "${mod}+q" = "kill";
      "${mod}+Shift+q" = "kill -SIGTERM";
      "${mod}+d" = "exec rofi -show combi";
    };
  };
}
