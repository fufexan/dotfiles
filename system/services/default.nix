{
  imports = [
    ./backlight.nix
    ./gnome-services.nix
    ./greetd.nix
    ./kanata
    ./location.nix
    ./pipewire.nix
    ./power.nix
    ./powersave.nix
  ];

  services = {
    dbus.implementation = "broker";

    # profile-sync-daemon
    psd = {
      enable = true;
      resyncTimer = "10m";
    };
  };
}
