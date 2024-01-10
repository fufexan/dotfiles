{
  config,
  pkgs,
  ...
}: {
  # notification daemon
  services.dunst = let
    xcolors = pkgs.lib.colors.xcolors config.programs.matugen.theme.colors;
    variant = config.theme.name;
    c = xcolors.colors.${variant};
  in {
    enable = true;
    inherit (config.gtk) iconTheme;
    settings = {
      global = {
        alignment = "center";
        corner_radius = 16;
        follow = "mouse";
        font = "Inter 9";
        format = "<b>%s</b>\\n%b";
        frame_width = 1;
        offset = "5x5";
        horizontal_padding = 8;
        icon_position = "left";
        indicate_hidden = "yes";
        markup = "yes";
        max_icon_size = 64;
        mouse_left_click = "do_action";
        mouse_middle_click = "close_all";
        mouse_right_click = "close_current";
        padding = 8;
        plain_text = "no";
        separator_color = "auto";
        separator_height = 1;
        show_indicators = false;
        shrink = "no";
        word_wrap = "yes";
      };

      fullscreen_delay_everything = {fullscreen = "delay";};

      urgency_critical = {
        background = c.error_container;
        foreground = c.on_error_container;
        frame_color = c.error;
      };
      urgency_low = {
        background = c.secondary_container;
        foreground = c.on_secondary_container;
        frame_color = c.secondary;
      };
      urgency_normal = {
        background = c.primary_container;
        foreground = c.on_primary_container;
        frame_color = c.primary;
      };
    };
  };
}
