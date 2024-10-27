{
  config,
  inputs,
  pkgs,
  ...
}: let
  font_family = "Inter";
in {
  programs.hyprlock = {
    enable = true;

    package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;

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

          outer_color = "rgb(b6c4ff)";
          inner_color = "rgb(dce1ff)";
          font_color = "rgb(354479)";

          fade_on_empty = false;
          placeholder_text = ''<span font_family="${font_family}" foreground="##354479">Password...</span>'';

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
          color = "rgb(b6c4ff)";

          position = "0, 150";

          valign = "center";
          halign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:3600000] date +'%a %b %d'";
          inherit font_family;
          font_size = 20;
          color = "rgb(b6c4ff)";

          position = "0, 50";

          valign = "center";
          halign = "center";
        }
      ];
    };
  };
}
