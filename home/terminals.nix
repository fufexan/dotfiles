{ pkgs, colors, ... }:

# terminals

let
  font = "JetBrainsMono Nerd Font";
  inherit (colors) x0 x fg bg normal bright;
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
      colors = {
        primary = {
          background = x0 bg;
          foreground = x0 fg;
        };
        #normal = map (e: v: e = x0 c.v.e) [ "black" "red" "green" "yellow" "blue" "magenta" "cyan" "white" ];
        normal = {
          black = x0 normal.black;
          red = x0 normal.red;
          green = x0 normal.green;
          yellow = x0 normal.yellow;
          blue = x0 normal.blue;
          magenta = x0 normal.magenta;
          cyan = x0 normal.cyan;
          white = x0 normal.white;
        };
        bright = {
          black = x0 bright.black;
          red = x0 bright.red;
          green = x0 bright.green;
          yellow = x0 bright.yellow;
          blue = x0 bright.blue;
          magenta = x0 bright.magenta;
          cyan = x0 bright.cyan;
          white = x0 bright.white;
        };
      };

      background_opacity = 0.9;
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
      foreground = x fg;
      background = x bg;
      # black
      color0 = x normal.black;
      color8 = x bright.black;
      # red
      color1 = x normal.red;
      color9 = x bright.red;
      # green
      color2 = x normal.green;
      color10 = x bright.green;
      # yellow
      color3 = x normal.yellow;
      color11 = x bright.yellow;
      # blue
      color4 = x normal.blue;
      color12 = x bright.blue;
      # magenta
      color5 = x normal.magenta;
      color13 = x bright.magenta;
      # cyan
      color6 = x normal.cyan;
      color14 = x bright.cyan;
      # white
      color7 = x normal.white;
      color15 = x bright.white;
    };
  };
}
