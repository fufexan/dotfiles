let
  desktop = [
    ./core/boot.nix
    ./core/default.nix

    ./hardware/opengl.nix

    ./network/avahi.nix
    ./network/default.nix
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
