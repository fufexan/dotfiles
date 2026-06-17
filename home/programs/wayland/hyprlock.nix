{
  config,
  inputs,
  pkgs,
  ...
}:
{
  programs.hyprlock = {
    enable = true;

    package = inputs.hyprlock.packages.${pkgs.stdenv.hostPlatform.system}.hyprlock;

    settings = {
      general = {
        immediate_render = true;
        hide_cursor = false;
      };

      animation = [
        "inputFieldDots, 1, 2, linear"
        "fade, 0"
      ];

      background = [
        {
          monitor = "";
          path = config.theme.wallpaper;
          blur_passes = 2;
          blur_size = 4;
        }
      ];

      input-field = [
        {
          monitor = "";

          size = "150, 30";
          valign = "bottom";
          position = "0%, 10%";

          outline_thickness = 1;

          font_color = "rgb(ffffff)";
          outer_color = "rgb(100, 100, 100)";
          inner_color = "rgb(100, 100, 100)";
          check_color = "rgb(255, 200, 0)";
          fail_color = "rgb(255, 100, 100)";

          fade_on_empty = false;
          placeholder_text = "Enter Password";

          dots_spacing = 0.2;
          dots_center = true;
          dots_fade_time = 100;

          shadow_color = "rgba(50, 50, 50, 0.1)";
          shadow_size = 3;
          shadow_passes = 2;
        }
      ];

      label = [
        {
          monitor = "";
          text = "<b>$TIME</b>";
          font_size = 150;
          color = "rgba(255, 255, 255, 0.4)";

          position = "0%, 30%";

          valign = "center";
          halign = "center";

          shadow_color = "rgba(50, 50, 50, 0.1)";
          shadow_size = 20;
          shadow_passes = 2;
          shadow_boost = 0.3;
        }
        {
          monitor = "";
          text = "cmd[update:3600000] date +'%a %b %d'";
          font_size = 20;
          color = "rgba(255, 255, 255, 0.3)";

          position = "0%, 40%";

          valign = "center";
          halign = "center";

          shadow_color = "rgba(50, 50, 50, 0.1)";
          shadow_size = 20;
          shadow_passes = 2;
          shadow_boost = 0.3;
        }
      ];
    };
  };
}
