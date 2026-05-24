{
  services.gammastep = {
    enable = true;
    tray = true;

    # stopgap until geoclue's wifi location is fixed
    provider = "geoclue2";

    enableVerboseLogging = true;

    settings.general.adjustment-method = "wayland";
  };
}
