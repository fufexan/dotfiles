{
  config,
  pkgs,
  lib,
  colors,
  ...
}:
# Wayland config
let
  xcolors = colors.xcolors;
in {
  imports = [
    ../eww
    ./hyprland
    ./sway.nix
  ];

  home.packages = with pkgs; [
    # screenshot
    grim
    slurp

    # idle/lock
    swaybg
    swaylock-effects

    # wm
    wayfire

    # utils
    wl-clipboard
    wlr-randr
    wlogout
    wofi
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
  };

  programs = {
    firefox.package = pkgs.firefox-wayland;

    mako = {
      enable = true;
      borderRadius = 16;
      borderSize = 0;
      defaultTimeout = 5000;
      font = "Roboto Regular 12";
      margin = "4,4";
      backgroundColor = xcolors.base01;
      textColor = xcolors.base06;
    };
  };

  services = {
    wlsunset = {
      enable = true;
      latitude = "46.0";
      longitude = "23.0";
    };
  };

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };
}
