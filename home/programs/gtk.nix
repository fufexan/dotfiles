{
  pkgs,
  config,
  ...
}: let
  inherit (config.programs.matugen) variant;
in {
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    enable = true;

    font = {
      name = "Roboto";
      package = pkgs.roboto;
      size = 9;
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    iconTheme = {
      name =
        "Papirus-"
        + (
          if variant == "light"
          then "Light"
          else "Dark"
        );
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name =
        if variant == "light"
        then "Catppuccin-Latte-Compact-Flamingo-Light"
        else "Catppuccin-Mocha-Compact-Flamingo-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["flamingo"];
        size = "compact";
        variant =
          if variant == "light"
          then "latte"
          else "mocha";
      };
    };
  };
}
