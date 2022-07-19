{
  config,
  pkgs,
  lib,
  colors,
  inputs,
  ...
}:
# Wayland config
let
  xcolors = colors.xcolors;

  _ = lib.getExe;

  ocrScript = pkgs.writeShellScriptBin "wl-ocr" ''
    ${_ pkgs.grim} -g "$(${_ pkgs.slurp})" -t ppm - | ${_ pkgs.tesseract5} - - | ${pkgs.wl-clipboard}/bin/wl-copy
    ${_ pkgs.libnotify} "$(${pkgs.wl-clipboard}/bin/wl-paste)"
  '';
in {
  imports = [
    ../eww
    ./libinput-gestures
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
    ocrScript
    wl-clipboard
    wlr-randr
    wlogout
    wofi
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  programs = {
    firefox.package = pkgs.firefox-wayland;

    mako = {
      # enable = true;
      package = inputs.self.packages.${pkgs.system}.mako;

      borderRadius = 16;
      borderSize = 0;
      defaultTimeout = 5000;
      font = "Roboto Regular 12";
      margin = "4,4";
      backgroundColor = xcolors.base01;
      textColor = xcolors.base06;
    };

    obs-studio.plugins = with pkgs.obs-studio-plugins; [wlrobs];
  };

  services = {
    gammastep = {
      enable = true;
      provider = "geoclue2";
    };
  };

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };
}
