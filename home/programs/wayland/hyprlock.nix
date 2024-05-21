{config, ...}: let
  variant = "dark";
  c = config.programs.matugen.theme.colors.colors.${variant};

  font_family = "Inter";
in {
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = false;
        no_fade_in = true;
      };

      background = [
        {
          monitor = "";
          path = config.theme.wallpaper;
        }
      ];

      input-field = [
        {
          monitor = "eDP-1";

          size = "300, 50";

          outline_thickness = 1;

          outer_color = "rgb(${c.primary})";
          inner_color = "rgb(${c.on_primary_container})";
          font_color = "rgb(${c.primary_container})";

          fade_on_empty = false;
          placeholder_text = ''<span font_family="${font_family}" foreground="##${c.primary_container}">Password...</span>'';

          dots_spacing = 0.2;
          dots_center = true;
        }
      ];

      label = [
        {
          monitor = "";
          text = "$TIME";
          inherit font_family;
          font_size = 50;
          color = "rgb(${c.primary})";

          position = "0, 80";

          valign = "center";
          halign = "center";
        }
      ];
    };
  };
}
