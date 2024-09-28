{
  imports = [
    # editors
    ../../editors/helix

    # programs
    ../../programs
    ../../programs/games
    ../../programs/wayland

    # services
    ../../services/ags
    # ../../services/cinny.nix

    # media services
    ../../services/media/playerctl.nix
    # ../../services/media/spotifyd.nix

    # system services
    ../../services/system/kdeconnect.nix
    ../../services/system/polkit-agent.nix
    ../../services/system/power-monitor.nix
    ../../services/system/syncthing.nix
    ../../services/system/tailray.nix
    ../../services/system/theme.nix
    ../../services/system/udiskie.nix

    # wayland-specific
    ../../services/wayland/gammastep.nix
    ../../services/wayland/hyprpaper.nix
    ../../services/wayland/hypridle.nix
    ../../services/wayland/wluma.nix

    # terminal emulators
    ../../terminal/emulators/foot.nix
    ../../terminal/emulators/wezterm.nix
  ];

  wayland.windowManager.hyprland.settings = let
    # Generated using https://gist.github.com/fufexan/e6bcccb7787116b8f9c31160fc8bc543
    accelpoints = "0.5 0.000 0.053 0.115 0.189 0.280 0.391 0.525 0.687 0.880 1.108 1.375 1.684 2.040 2.446 2.905 3.422 4.000 4.643 5.355 6.139";
  in {
    monitor = [
      # "DP-1, preferred, auto-left, auto"
      # "DP-2, preferred, auto-left, auto"
      "eDP-1, preferred, auto, 1.600000"
    ];

    device = {
      name = "elan2841:00-04f3:31eb-touchpad";
      accel_profile = "custom ${accelpoints}";
      scroll_points = accelpoints;
      natural_scroll = true;
    };
  };
}
