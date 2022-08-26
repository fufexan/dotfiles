{
  colors,
  default,
  pkgs,
  ...
}:
# terminals
let
  inherit (colors) x0Colors;
  inherit (default.terminal) font size;
in {
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
        inherit size;
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
        bright =
          normal
          // {
            black = x0Colors.base03;
            white = x0Colors.base06;
          };
      };
      window.opacity = default.terminal.opacity;
    };
  };
}
