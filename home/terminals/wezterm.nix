{default, ...}: {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require "wezterm"

      return {
        font = wezterm.font_with_fallback({ "${default.terminal.font}", }, {
          weight = "Regular",
        }),
        font_size = ${toString default.terminal.size},
        color_scheme = "Catppuccin Mocha",
        window_background_opacity = ${toString default.terminal.opacity},
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
}
