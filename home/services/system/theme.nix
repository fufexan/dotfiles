{
  lib,
  pkgs,
  ...
}:
{
  services.darkman = {
    enable = true;

    settings.usegeoclue = true;

    # sets the freedesktop color-scheme preference; GTK/libadwaita and Qt (via
    # hyprqt6engine's KColorScheme) follow it
    scripts.dconf = ''${lib.getExe pkgs.dconf} write /org/gnome/desktop/interface/color-scheme "'prefer-$1'"'';
  };

  # make sure HYPRLAND_INSTANCE_SIGNATURE is set, so hyprctl can use it
  systemd.user.services.darkman.Unit.After = [ "graphical-session.target" ];
}
