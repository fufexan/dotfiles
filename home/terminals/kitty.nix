{
  default,
  ...
}: let
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
      visual_bell_color = xcolors.base05;

      copy_on_select = "clipboard";

      selection_foreground = "none";
      selection_background = "none";

      # colors
      background_opacity = toString default.terminal.opacity;
      foreground = xcolors.base05;
      background = xcolors.base00;
      # black
      color0 = xcolors.base02;
      color8 = xcolors.base03;
      # red
      color1 = xcolors.base08;
      color9 = xcolors.base08;
      # green
      color2 = xcolors.base0B;
      color10 = xcolors.base0B;
      # yellow
      color3 = xcolors.base0A;
      color11 = xcolors.base0A;
      # blue
      color4 = xcolors.base0D;
      color12 = xcolors.base0D;
      # magenta
      color5 = xcolors.base0E;
      color13 = xcolors.base0E;
      # cyan
      color6 = xcolors.base0C;
      color14 = xcolors.base0C;
      # white
      color7 = xcolors.base05;
      color15 = xcolors.base06;
    };
  };
}
