{
  services = {
    logind.settings.Login.HandlePowerKey = "suspend";

    power-profiles-daemon.enable = true;

    # battery info
    upower.enable = true;

    udev.extraRules = /* udev */ ''
      # Enable PCI runtime power management on all devices.
      ACTION=="add", SUBSYSTEM=="pci", ATTR{power/control}="auto"
    '';
  };
}
