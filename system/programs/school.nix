{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gns3-gui
    inetutils
  ];

  services.gns3-server = {
    enable = true;
    dynamips.enable = true;
    ubridge.enable = true;
    vpcs.enable = true;
  };

  # Allow plugdev group to use Analog Devices' ADALM Pluto devices
  users.groups.plugdev = { };
  users.users.mihai.extraGroups = [ "plugdev" ];

  services.udev.packages =
    let
      adi-plutosdr-usb = pkgs.writeTextFile {
        name = "53-adi-plutosdr-usb";
        destination = "/etc/udev/rules.d/53-adi-plutosdr-usb.rules";
        text = ''
          # allow "plugdev" group read/write access to ADI PlutoSDR devices
          # DFU Device
          SUBSYSTEM=="usb", ATTRS{idVendor}=="0456", ATTRS{idProduct}=="b674", MODE="0664", GROUP="plugdev"
          SUBSYSTEM=="usb", ATTRS{idVendor}=="2fa2", ATTRS{idProduct}=="5a32", MODE="0664", GROUP="plugdev"
          # SDR Device
          SUBSYSTEM=="usb", ATTRS{idVendor}=="0456", ATTRS{idProduct}=="b673", MODE="0664", GROUP="plugdev"
          SUBSYSTEM=="usb", ATTRS{idVendor}=="2fa2", ATTRS{idProduct}=="5a02", MODE="0664", GROUP="plugdev"
          # tell the ModemManager (part of the NetworkManager suite) that the device is not a modem,
          # and don't send AT commands to it
          SUBSYSTEM=="usb", ATTRS{idVendor}=="0456", ATTRS{idProduct}=="b673", ENV{ID_MM_DEVICE_IGNORE}="1"
          SUBSYSTEM=="usb", ATTRS{idVendor}=="2fa2", ATTRS{idProduct}=="5a02", ENV{ID_MM_DEVICE_IGNORE}="1"
        '';
      };

      adi-m2k-usb = pkgs.writeTextFile {
        name = "53-adi-m2k-usb";
        destination = "/etc/udev/rules.d/53-adi-m2k-usb.rules";
        text = ''
          # allow "plugdev" group read/write access to ADI M2K devices
          SUBSYSTEM=="usb", ATTRS{idVendor}=="0456", ATTRS{idProduct}=="b672", MODE="0664", GROUP="plugdev"
          SUBSYSTEM=="usb", ATTRS{idVendor}=="0456", ATTRS{idProduct}=="b675", MODE="0664", GROUP="plugdev"
          # tell the ModemManager (part of the NetworkManager suite) that the device is not a modem,
          # and don't send AT commands to it
          SUBSYSTEM=="usb", ATTRS{idVendor}=="0456", ATTRS{idProduct}=="b672", ENV{ID_MM_DEVICE_IGNORE}="1"
        '';
      };
    in
    [
      adi-plutosdr-usb
      adi-m2k-usb
    ];
}
