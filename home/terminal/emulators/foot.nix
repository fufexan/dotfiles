{
  pkgs,
  lib,
  ...
}: let
  colors = {
    dark = {
      foreground = "979eab";
      background = "282c34";
      regular0 = "282c34"; # black
      regular1 = "e06c75"; # red
      regular2 = "98c379"; # green
      regular3 = "e5c07b"; # yellow
      regular4 = "61afef"; # blue
      regular5 = "be5046"; # magenta
      regular6 = "56b6c2"; # cyan
      regular7 = "979eab"; # white
      bright0 = "393e48"; # bright black
      bright1 = "d19a66"; # bright red
      bright2 = "56b6c2"; # bright green
      bright3 = "e5c07b"; # bright yellow
      bright4 = "61afef"; # bright blue
      bright5 = "be5046"; # bright magenta
      bright6 = "56b6c2"; # bright cyan
      bright7 = "abb2bf"; # bright white
    };

    light = {
      foreground = "4c4f69"; # Text
      background = "eff1f5"; # Base
      regular0 = "bcc0cc"; # Surface 1
      regular1 = "d20f39"; # red
      regular2 = "40a02b"; # green
      regular3 = "df8e1d"; # yellow
      regular4 = "1e66f5"; # blue
      regular5 = "e64553"; # maroon
      regular6 = "179299"; # teal
      regular7 = "5c5f77"; # Subtext 1
      bright0 = "acb0be"; # Surface 2
      bright1 = "d20f39"; # red
      bright2 = "40a02b"; # green
      bright3 = "df8e1d"; # yellow
      bright4 = "1e66f5"; # blue
      bright5 = "e64553"; # maroon
      bright6 = "179299"; # teal
      bright7 = "6c6f85"; # Subtext 0
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
        protocols = "http, https, ftp, ftps, file, mailto, ipfs";
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
