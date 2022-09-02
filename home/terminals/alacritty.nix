{
  colors,
  default,
  pkgs,
  ...
}:
# terminals
let
  inherit (colors) xcolors;
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
          background = xcolors.base00;
          foreground = xcolors.base05;
        };
        normal = {
          black = xcolors.base02;
          red = xcolors.base08;
          green = xcolors.base0B;
          yellow = xcolors.base0A;
          blue = xcolors.base0D;
          magenta = xcolors.base0E;
          cyan = xcolors.base0C;
          white = xcolors.base05;
        };
        bright =
          normal
          // {
            black = xcolors.base03;
            white = xcolors.base06;
          };
      };
      window.opacity = default.terminal.opacity;
    };
  };
}
