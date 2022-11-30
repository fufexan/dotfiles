{default, ...}: let
  inherit (default) xcolors;
in {
  programs.kitty = {
    enable = true;
    font = {
      inherit (default.terminal) size;
      name = default.terminal.font;
    };
    settings = {
      scrollback_lines = 10000;
      placement_strategy = "center";

      allow_remote_control = "yes";
      enable_audio_bell = "no";
      visual_bell_duration = "0.1";
      visual_bell_color = xcolors.rosewater;

      copy_on_select = "clipboard";

      selection_foreground = "none";
      selection_background = "none";

      # colors
      background_opacity = toString default.terminal.opacity;
      foreground = xcolors.fg;
      background = xcolors.crust;
      # black
      color0 = xcolors.mantle;
      color8 = xcolors.base;
      # red
      color1 = xcolors.red;
      color9 = xcolors.red;
      # green
      color2 = xcolors.green;
      color10 = xcolors.green;
      # yellow
      color3 = xcolors.yellow;
      color11 = xcolors.yellow;
      # blue
      color4 = xcolors.blue;
      color12 = xcolors.blue;
      # magenta
      color5 = xcolors.pink;
      color13 = xcolors.pink;
      # cyan
      color6 = xcolors.sky;
      color14 = xcolors.sky;
      # white
      color7 = xcolors.text;
      color15 = xcolors.rosewater;
    };
  };
}
