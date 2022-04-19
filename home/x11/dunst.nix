{pkgs, ...}: {
  # notification daemon
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    settings = {
      global = {
        alignment = "center";
        corner_radius = 10;
        follow = "mouse";
        font = "Noto Sans 10";
        format = "<b>%s</b>\\n%b";
        frame_width = 2;
        geometry = "400x5-4+32";
        horizontal_padding = 8;
        icon_position = "left";
        indicate_hidden = "yes";
        markup = "yes";
        max_icon_size = 96;
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
        background = "#16161c";
        foreground = "#fdf0ed";
        frame_color = "#e95678";
      };
      urgency_low = {
        background = "#16161c";
        foreground = "#fdf0ed";
        frame_color = "#29d398";
      };
      urgency_normal = {
        background = "#16161c";
        foreground = "#fdf0ed";
        frame_color = "#fab795";
      };
    };
  };
}
