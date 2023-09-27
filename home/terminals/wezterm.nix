{
  default,
  theme,
  ...
}: let
  variant =
    if theme.variant == "light"
    then "Latte"
    else "Mocha";
in {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require "wezterm"

      return {
        font_size = ${toString default.terminal.size},
        color_scheme = 'Catppuccin ${variant}',
        window_background_opacity = ${toString default.terminal.opacity},
        enable_scroll_bar = false,
        hide_tab_bar_if_only_one_tab = true,
        scrollback_lines = 10000,
        check_for_updates = false,
        default_cursor_style = 'SteadyBar',
      }
    '';
  };
}
