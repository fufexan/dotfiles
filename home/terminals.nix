{ colors, ... }:

# terminals

let
  inherit (colors) xcolors x0Colors;
  font = "JetBrainsMono Nerd Font";
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        decorations = "none";
        dynamic_padding = true;
        padding = {
          x = 5;
          y = 5;
        };
        startup_mode = "Maximized";
      };

      scrolling.history = 10000;

      font = {
        normal.family = font;
        bold.family = font;
        italic.family = font;
        size = 11;
      };

      draw_bold_text_with_bright_colors = true;
      colors = rec {
        primary = {
          background = x0Colors.base00;
          foreground = x0Colors.base05;
        };
        normal = {
          black = x0Colors.base02;
          red = x0Colors.base08;
          green = x0Colors.base0B;
          yellow = x0Colors.base0A;
          blue = x0Colors.base0D;
          magenta = x0Colors.base0E;
          cyan = x0Colors.base0C;
          white = x0Colors.base05;
        };
        bright = normal // { black = x0Colors.base03; white = x0Colors.base06; };
      };

      window.opacity = 0.9;
    };
  };

  programs.kitty = {
    enable = false;
    font.name = font;
    font.size = 12;
    settings = {
      scrollback_lines = 10000;
      window_padding_width = 4;

      allow_remote_control = "yes";

      # colors
      background_opacity = "0.7";
      foreground = xcolors.base00;
      background = xcolors.base05;
      # black
      color0 = xcolors.base02;
      color8 = xcolors.base03;
      # red
      color1 = xcolors.base08;
      color9 = xcolors.base08;
      # green
      color2 = xcolors.baseOB;
      color10 = xcolors.baseOB;
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
