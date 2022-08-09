{
  colors,
  pkgs,
  ...
}:
# terminals
let
  inherit (colors) xcolors x0Colors;
  font = "JetBrainsMono Nerd Font";
  size = 11;
in {
  programs = {
    alacritty = {
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

        window.opacity = 0.9;
      };
    };

    kitty = {
      enable = true;
      font = {
        inherit size;
        name = font;
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
        background_opacity = "0.9";
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

    wezterm = {
      enable = true;
      extraConfig = ''
        local wezterm = require "wezterm"

        return {
          font = wezterm.font_with_fallback({ "${font}", }, {
            weight = "Regular",
          }),
          font_size = ${toString size},
          color_scheme = "Catppuccin Mocha",
          window_background_opacity = 0.9,
          enable_scroll_bar = true,
          enable_tab_bar = false,
          window_padding = {
            left = 5,
            right = 5,
            top = 5,
            bottom = 5,
          },
          check_for_updates = false,
          default_cursor_style = "SteadyBar",
        }
      '';
    };
  };
}
