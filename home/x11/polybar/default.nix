{pkgs, ...}: let
  mprisScript = pkgs.callPackage ./mpris.nix {};
in {
  services.polybar = {
    enable = true;
    package = pkgs.polybarFull;

    config = {
      "colors" = {
        "foreground" = "\${xrdb:color15:#fdf0ed}";
        "background" = "\${xrdb:color0:#16161c}";

        "primary" = "\${colors.green}";
        "secondary" = "\${xrdb:color11}";

        "black" = "\${xrdb:color0}";
        "red" = "\${xrdb:color1}";
        "green" = "\${xrdb:color2}";
        "yellow" = "\${xrdb:color3}";
        "blue" = "\${xrdb:color4}";
        "magenta" = "\${xrdb:color5}";
        "cyan" = "\${xrdb:color6}";
        "white" = "\${xrdb:color7}";

        "alert" = "\${colors.red}";
      };

      # bars
      "layout" = {
        "width" = "100%";
        "height" = "30";

        "module-margin" = "3";
        "padding-right" = "3";

        "font-0" = "Noto Sans:size=12;3";
        "font-1" = "Material Design Icons:size=12:antialias=true;3.5";
        "font-2" = "FiraCode Nerd Font:size=7;2";

        "modules-left" = "bspwm cpu temperature memory";
        "modules-center" = "mpris";
        "modules-right" = "backlight wireless-network battery pulseaudio date";

        "tray-position" = "right";

        "wm-restack" = "bspwm";

        # #argb
        "background" = "#cd16161c";
        "foreground" = "\${colors.foreground}";

        "line-size" = "1";
      };

      "bar/main" = {
        "monitor" = "";
        "inherit" = "layout";
      };

      # modules
      "module/backlight" = {
        "type" = "internal/xbacklight";

        "format" = "<ramp>";
        "format-foreground" = "\${colors.yellow}";

        "ramp-0" = "%{T1}";
        "ramp-1" = "%{T1}";
        "ramp-2" = "%{T1}";
        "ramp-3" = "%{T1}";
        "ramp-4" = "%{T1}";
        "ramp-5" = "%{T1}";
        "ramp-6" = "%{T1}";
      };

      "module/battery" = {
        "type" = "internal/battery";
        "full-at" = "98";

        "format-charging" = "<animation-charging> <label-charging>";

        "label-charging" = "%percentage%% %consumption%W";
        "label-discharging" = "%percentage%% %consumption%W";
        "label" = "%percentage%%";

        "ramp-capacity-0" = "󰁺";
        "ramp-capacity-0-foreground" = "\${colors.red}";
        "ramp-capacity-1" = "󰁻";
        "ramp-capacity-1-foreground" = "\${colors.foreground}";
        "ramp-capacity-2" = "󰁼";
        "ramp-capacity-3" = "󰁽";
        "ramp-capacity-4" = "󰁾";
        "ramp-capacity-5" = "󰁿";
        "ramp-capacity-6" = "󰂀";
        "ramp-capacity-7" = "󰂁";
        "ramp-capacity-8" = "󰂂";
        "ramp-capacity-9" = "󰁹";

        "animation-charging-0" = "󰂆";
        "animation-charging-1" = "󰂇";
        "animation-charging-2" = "󰂈";
        "animation-charging-3" = "󰂉";
        "animation-charging-4" = "󰂋";
        "animation-charging-5" = "󰂅";
        "animation-charging-framerate" = 750;
        "animation-charging-foreground" = "\${colors.green}";
      };

      "module/cpu" = {
        "type" = "internal/cpu";
        "interval" = "0.5";
        "format" = "<label> <ramp-coreload>";
        "label" = "󰍛 %percentage%%";
        "format-foreground" = "\${colors.green}";

        "ramp-coreload-0" = "▁";
        "ramp-coreload-0-font" = 2;
        "ramp-coreload-0-foreground" = "\${colors.primary}";
        "ramp-coreload-1" = "▂";
        "ramp-coreload-1-font" = 2;
        "ramp-coreload-1-foreground" = "\${colors.primary}";
        "ramp-coreload-2" = "▃";
        "ramp-coreload-2-font" = 2;
        "ramp-coreload-2-foreground" = "\${colors.primary}";
        "ramp-coreload-3" = "▄";
        "ramp-coreload-3-font" = 2;
        "ramp-coreload-3-foreground" = "\${colors.primary}";
        "ramp-coreload-4" = "▅";
        "ramp-coreload-4-font" = 2;
        "ramp-coreload-4-foreground" = "\${colors.secondary}";
        "ramp-coreload-5" = "▆";
        "ramp-coreload-5-font" = 2;
        "ramp-coreload-5-foreground" = "\${colors.secondary}";
        "ramp-coreload-6" = "▇";
        "ramp-coreload-6-font" = 2;
        "ramp-coreload-6-foreground" = "\${colors.secondary}";
        "ramp-coreload-7" = "█";
        "ramp-coreload-7-font" = 2;
        "ramp-coreload-7-foreground" = "\${colors.alert}";
      };

      "module/date" = {
        "type" = "internal/date";
        "date" = "󰥔 %H:%M %d/%m";
        "date-alt" = "󰃭 %A, %d %B %Y %H:%M:%S";
        "format-foreground" = "\${colors.cyan}";
      };

      "module/memory" = {
        "type" = "internal/memory";
        "format" = "<label>";
        "format-foreground" = "\${colors.blue}";
        "label" = "󰇖 %gb_used%";
      };

      "module/wireless-network" = {
        "type" = "internal/network";
        "interval" = 3;
        "ping-interval" = 10;

        "format-connected" = "<ramp-signal> <label-connected>";
        "label-connected" = "%essid%";
        "label-disconnected" = "󰤭";
        "label-disconnected-foreground" = "#66";

        "ramp-signal-0" = "󰤯";
        "ramp-signal-1" = "󰤟";
        "ramp-signal-2" = "󰤢";
        "ramp-signal-3" = "󰤥";
        "ramp-signal-4" = "󰤨";
      };

      "module/temperature" = {
        "type" = "internal/temperature";
        "interval" = 1;
        "units" = true;

        "format" = "<ramp> <label>";
        "format-warn" = "<ramp> <label-warn>";
        "format-foreground" = "\${colors.yellow}";
        "label-warn-foreground" = "\${colors.alert}";

        "ramp-0" = "󱃃";
        "ramp-1" = "󰔏";
        "ramp-2" = "󱃂";
      };

      "module/bspwm" = {
        "type" = "internal/bspwm";

        "ws-icon-default" = "󰍹";

        "format" = "<label-state> <label-mode>";

        "label-focused" = "%name%";
        "label-focused-foreground" = "\${colors.green}";
        "label-focused-padding" = 2;

        "label-occupied" = "%name%";
        "label-occupied-foreground" = "\${colors.yellow}";
        "label-occupied-padding" = 2;

        "label-urgent" = "%name%";
        "label-urgent-foreground" = "\${colors.background}";
        "label-urgent-background" = "\${colors.alert}";
        "label-urgent-padding" = 2;

        "label-empty" = "";
        "label-monocle" = "󰍉";
        "label-monocle-foreground" = "\${colors.background}";
        "label-monocle-background" = "\${colors.secondary}";
        "label-monocle-padding" = 1;
      };

      "module/mpris" = {
        "type" = "custom/script";

        "exec" = "${mprisScript}/bin/mpris";
        "tail" = "true";

        "label-maxlen" = 100;

        "interval" = 1;
        "format" = "󰎆 <label>";
        "format-padding" = 2;
      };

      "module/pulseaudio" = {
        "type" = "internal/pulseaudio";
        "sink" = "";
        "use-ui-max" = false;
        "interval" = 5;
        "click-right" = "${pkgs.pavucontrol}/bin/pavucontrol";

        "format-volume" = "<ramp-volume> <label-volume>";
        "format-volume-foreground" = "\${colors.magenta}";
        "label-muted" = "󰸈 muted";
        "label-muted-foreground" = "\${colors.magenta}";

        "ramp-volume-0" = "󰕿";
        "ramp-volume-1" = "󰖀";
        "ramp-volume-2" = "󰕾";
      };
    };

    script = ''
      polybar main &
    '';
  };
}
