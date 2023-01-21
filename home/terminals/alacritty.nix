{default, ...}:
# terminals
let
  inherit (default.terminal) font size opacity;
  inherit (default) xcolors;
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
          background = xcolors.crust;
          foreground = xcolors.fg;
        };
        normal = {
          inherit (xcolors) red green yellow blue;
          black = xcolors.mantle;
          magenta = xcolors.mauve;
          cyan = xcolors.sky;
          white = xcolors.text;
        };
        bright =
          normal
          // {
            black = xcolors.base;
            white = xcolors.rosewater;
          };
      };
      window.opacity = opacity;
    };
  };
}
