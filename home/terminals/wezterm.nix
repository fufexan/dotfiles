{default, ...}: {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require "wezterm"

      return {
        font = wezterm.font_with_fallback {
          "${default.terminal.font}",
          "Material Symbols Outlined"
        },
        font_size = ${toString default.terminal.size},
        color_scheme = "Catppuccin Mocha",
        window_background_opacity = ${toString default.terminal.opacity},
        enable_scroll_bar = false,
        enable_tab_bar = false,
        scrollback_lines = 10000,
        window_padding = {
          left = 10,
          right = 10,
          top = 10,
          bottom = 10,
        },
        check_for_updates = false,
        default_cursor_style = "SteadyBar",
      }
    '';
  };
}
