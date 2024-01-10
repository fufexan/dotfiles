{
  services = {
    logind.extraConfig = ''
      HandlePowerKey=suspend
    '';

    power-profiles-daemon.enable = true;

    # battery info
    upower.enable = true;
  };
}
