# home server configuration
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  networking.hostName = "tosh";

  services = {
    pipewire.lowLatency.enable = true;
    upower.enable = true;
    tlp.enable = true;
  };
}
