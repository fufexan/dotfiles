{ pkgs, ... }: {
  services = {
    ddccontrol = {
      enable = true;
      package = pkgs.ddcutil-service;
    };

    # Detect monitors on plug/boot
    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="drm", ENV{DEVTYPE}=="drm_connector", ENV{DRM_CONNECTOR_FOR}="$name"
      ACTION=="add", SUBSYSTEM=="i2c", IMPORT{parent}="DRM_CONNECTOR_FOR"
      ACTION=="add", SUBSYSTEM=="i2c", ENV{DRM_CONNECTOR_FOR}=="?*", ATTR{new_device}="ddcci 0x37"
    '';
  };
}
