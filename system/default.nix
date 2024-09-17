let
  desktop = [
    ./core
    ./core/boot.nix

    ./hardware/fwupd.nix
    ./hardware/graphics.nix

    ./network
    ./network/avahi.nix
    ./network/tailscale.nix

    ./programs

    ./services
    ./services/greetd.nix
    ./services/pipewire.nix
  ];

  laptop =
    desktop
    ++ [
      ./hardware/bluetooth.nix

      ./services/backlight.nix
      ./services/power.nix
    ];
in {
  inherit desktop laptop;
}
