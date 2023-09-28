{
  pkgs,
  config,
  theme,
  ...
}: {
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
          if theme.variant == "light"
          then "Light"
          else "Dark"
        );
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name =
        if theme.variant == "light"
        then "Catppuccin-Latte-Compact-Flamingo-light"
        else "Catppuccin-Mocha-Compact-Flamingo-dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["flamingo"];
        size = "compact";
        variant =
          if theme.variant == "light"
          then "latte"
          else "mocha";
      };
    };
  };
}
