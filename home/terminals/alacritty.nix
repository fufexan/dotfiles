{
  pkgs,
  default,
  ...
}:
# terminals
let
  inherit (default.terminal) font size opacity;
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
      window.opacity = opacity;

      imports = [
        (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/catppuccin/alacritty/3c808cbb4f9c87be43ba5241bc57373c793d2f17/catppuccin-mocha.yml";
          hash = "sha256-28Tvtf8A/rx40J9PKXH6NL3h/OKfn3TQT1K9G8iWCkM=";
        })
      ];
    };
  };
}
