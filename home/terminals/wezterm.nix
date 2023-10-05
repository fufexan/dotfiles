{default, ...}: {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require "wezterm"

      -- wezterm.gui is not available to the mux server, so take care to
      -- do something reasonable when this config is evaluated by the mux
      function get_appearance()
        if wezterm.gui then
          return wezterm.gui.get_appearance()
        end
        return 'Dark'
      end

      function scheme_for_appearance(appearance)
        if appearance:find 'Dark' then
          return 'Catppuccin Mocha'
        else
          return 'Catppuccin Latte'
        end
      end

      return {
        check_for_updates = false,
        color_scheme = scheme_for_appearance(get_appearance()),
        default_cursor_style = 'SteadyBar',
        enable_kitty_keyboard = true,
        enable_scroll_bar = false,
        font_size = ${toString default.terminal.size},
        hide_tab_bar_if_only_one_tab = true,
        scrollback_lines = 10000,
        window_background_opacity = ${toString default.terminal.opacity},
      }
    '';
  };
}
