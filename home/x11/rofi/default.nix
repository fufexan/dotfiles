{ config, pkgs, ... }:

# rofi config

{
  programs = {
    rofi = {
      enable = true;
      package = pkgs.rofi.override { plugins = [ pkgs.rofi-emoji ]; };

      extraConfig = {
        show-icons = true;
        icon-theme = "Papirus";
        display-drun = "";
        display-combi = "";
        drun-display-format = "{name}";
        combi-modi = "drun,run";
      };

      font = "Roboto 14";
      fullscreen = false;

      theme =
        let
          inherit (config.lib.formats.rasi) mkLiteral;
          colors = import ../../colors.nix;
        in
        {
          "*" = {
            accent = mkLiteral "#${colors.normal.yellow}";
            on = mkLiteral "#${colors.normal.green}";
            off = mkLiteral "#${colors.normal.red}";
            foreground = mkLiteral "#${colors.fg}";
            background = mkLiteral "#${colors.bg}";
          };

          window = {
            transparency = "real";
            background-color = mkLiteral "#${colors.bg}55"; # rofi uses rgba
            border = mkLiteral "2px";
            border-color = mkLiteral "@accent";
            border-radius = mkLiteral "10px";
            height = mkLiteral "53%";
            width = mkLiteral "50%";
          };

          entry = {
            background-color = mkLiteral "#0000";
            text-color = mkLiteral "@foreground";
            placeholder = "Search...";
            placeholder-color = mkLiteral "#666";
            horizontal-align = mkLiteral "0.5";
            blink = true;
          };

          inputbar = {
            children = map mkLiteral [ "entry" ];
            background-color = mkLiteral "#0000";
            text-color = mkLiteral "@foreground";
          };

          listview = {
            background-color = mkLiteral "#0000";
            columns = 5;
            spacing = mkLiteral "1%";
            cycle = true;
            layout = mkLiteral "vertical";
          };

          mainbox = {
            background-color = mkLiteral "#0000";
            children = map mkLiteral [ "inputbar" "listview" ];
            spacing = mkLiteral "2%";
            padding = mkLiteral "1em";
          };

          element = {
            background-color = mkLiteral "#0000";
            text-color = mkLiteral "@foreground";
            orientation = mkLiteral "vertical";
            padding = mkLiteral "2.5% 0%";
          };

          element-icon.size = mkLiteral "64px";

          element-text = {
            horizontal-align = mkLiteral "0.5";
            vertical-algin = mkLiteral "0.5";
          };

          "element selected" = {
            background-color = mkLiteral "@accent";
            border-radius = mkLiteral "10px";
            text-color = mkLiteral "@background";
          };

          "element selected.urgent" = {
            background-color = mkLiteral "@off";
            text-color = mkLiteral "@background";
          };

          "element selected.active" = {
            background-color = mkLiteral "@on";
            color = mkLiteral "@foreground";
          };
        };
    };

    rofi.pass = {
      enable = true;
      extraConfig = ''
        URL_field='url';
        USERNAME_field='user';
      '';
      stores = [ "$HOME/.local/share/password-store" ];
    };
  };
}
