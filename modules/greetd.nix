{
  pkgs,
  config,
  default,
  ...
}:
# greetd display manager
let
  inherit (config.programs.matugen) variant;

  themeName =
    if variant == "light"
    then "Catppuccin-Latte-Compact-Flamingo-Light"
    else "Catppuccin-Mocha-Compact-Flamingo-Dark";

  themePackage = pkgs.catppuccin-gtk.override {
    accents = ["flamingo"];
    size = "compact";
    variant =
      if variant == "light"
      then "latte"
      else "mocha";
  };
in {
  environment.systemPackages = with pkgs; [
    # theme packages
    themePackage
    bibata-cursors
    gnome.adwaita-icon-theme
  ];

  programs.regreet = {
    enable = true;

    cageArgs = ["-s" "-m" "last"];

    settings = {
      background = {
        path = default.wallpaper;
        fit = "Cover";
      };
      GTK = {
        cursor_theme_name = "Bibata-Modern-Classic";
        font_name = "Inter 9";
        icon_theme_name = "Adwaita";
        theme_name = themeName;
      };
    };
  };

  # unlock GPG keyring on login
  security.pam.services.greetd.enableGnomeKeyring = true;
}
