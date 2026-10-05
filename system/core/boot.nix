{
  pkgs,
  config,
  lib,
  ...
}:
{
  boot = {
    initrd = {
      systemd.enable = true;
      supportedFilesystems = [ "ext4" ];
    };

    # use latest kernel (mkDefault so hosts can override without mkForce)
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
      "plymouth.use-simpledrm"
    ];

    loader = {
      # systemd-boot on UEFI
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };

    plymouth.enable = true;
  };

  environment.systemPackages = [ config.boot.kernelPackages.cpupower ];
}
