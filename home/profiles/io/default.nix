{
  imports = [
    # editors
    ../../editors/helix
    # ../../editors/jetbrains/idea.nix

    # programs
    ../../programs
    ../../programs/games
    ../../programs/wayland

    # services
    # ../../services/ags
    ../../services/quickshell

    # media services
    ../../services/media/playerctl.nix

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

    # terminal emulators
    ../../terminal/emulators/foot.nix
  ];
}
