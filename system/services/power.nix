{
  services = {
    logind.settings.Login.HandlePowerKey = "suspend";

    power-profiles-daemon.enable = true;

    # battery info
    upower.enable = true;
  };
}
