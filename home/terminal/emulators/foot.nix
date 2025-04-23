{
  pkgs,
  lib,
  ...
}: let
  colors = {
    dark = {
      foreground = "abb2bf";
      background = "1e2127";
      regular0 = "1e2127"; # black
      regular1 = "e06c75"; # red
      regular2 = "98c379"; # green
      regular3 = "d19a66"; # yellow
      regular4 = "61afef"; # blue
      regular5 = "c678dd"; # magenta
      regular6 = "56b6c2"; # cyan
      regular7 = "abb2bf"; # white
      bright0 = "5c6370"; # bright black
      bright1 = "e06c75"; # bright red
      bright2 = "98c379"; # bright green
      bright3 = "d19a66"; # bright yellow
      bright4 = "61afef"; # bright blue
      bright5 = "c678dd"; # bright magenta
      bright6 = "56b6c2"; # bright cyan
      bright7 = "ffffff"; # bright white
    };

    light = {
      foreground = "383a42"; # Text
      background = "f9f9f9"; # Base
      regular0 = "000000"; # Surface 1
      regular1 = "e45649"; # red
      regular2 = "50a14f"; # green
      regular3 = "986801"; # yellow
      regular4 = "4078f2"; # blue
      regular5 = "a626a4"; # maroon
      regular6 = "0184bc"; # teal
      regular7 = "a0a1a7"; # Subtext 1
      bright0 = "383a42"; # Surface 2
      bright1 = "e45649"; # red
      bright2 = "50a14f"; # green
      bright3 = "986801"; # yellow
      bright4 = "4078f2"; # blue
      bright5 = "a626a4"; # maroon
      bright6 = "0184bc"; # teal
      bright7 = "ffffff"; # Subtext 0
    };
  };
in {
  programs.foot = {
    enable = true;

    settings = {
      main = {
        font = "JetBrains Mono Nerd Font:size=10";
        horizontal-letter-offset = 0;
        vertical-letter-offset = 0;
        pad = "4x4 center";
        selection-target = "clipboard";
      };

      bell = {
        urgent = "yes";
        notify = "yes";
      };

      desktop-notifications = {
        command = "${lib.getExe pkgs.libnotify} -a \${app-id} -i \${app-id} \${title} \${body}";
      };

      scrollback = {
        lines = 10000;
        multiplier = 3;
        indicator-position = "relative";
        indicator-format = "line";
      };

      url = {
        launch = "${pkgs.xdg-utils}/bin/xdg-open \${url}";
      };

      cursor = {
        style = "beam";
        beam-thickness = 1;
      };

      colors =
        {
          alpha = 0.9;
        }
        // colors.dark;
    };
  };
}
