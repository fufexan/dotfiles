{
  services = {
    logind.powerKey = "suspend";

    power-profiles-daemon.enable = true;

    # battery info
    upower.enable = true;
  };
}
