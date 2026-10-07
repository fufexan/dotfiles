{
  pkgs,
  config,
  lib,
  ...
}:
{
  # darkman -> GTK3 legacy apps: flip the gtk-theme name live. libadwaita/GTK4
  # apps instead follow the color-scheme set by theme.nix's dconf script.
  services.darkman.scripts.gtk3 = ''
    variant=""
    [ "$1" = "dark" ] && variant="-dark"
    ${lib.getExe' pkgs.glib "gsettings"} set org.gnome.desktop.interface gtk-theme "adw-gtk3$variant" || true
  '';

  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    enable = true;

    font = {
      name = "Inter";
      package = pkgs.google-fonts.override { fonts = [ "Inter" ]; };
      size = 9;
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    gtk4.theme = null;

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
  };
}
