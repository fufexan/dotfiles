{
  pkgs,
  colors,
  ...
}: let
  x = colors.xcolors;
in {
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
        corner_radius = 16;
        follow = "mouse";
        font = "Roboto 10";
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
        background = x.base00;
        foreground = x.base06;
        frame_color = x.base08;
      };
      urgency_low = {
        background = x.base00;
        foreground = x.base06;
        frame_color = x.base05;
      };
      urgency_normal = {
        background = x.base00;
        foreground = x.base06;
        frame_color = x.base06;
      };
    };
  };
}
