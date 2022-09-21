{
  pkgs,
  lib,
  config,
  colors,
  ...
}:
# Wayland config
let
  _ = lib.getExe;

  ocrScript = pkgs.writeShellScriptBin "wl-ocr" ''
    ${_ pkgs.grim} -g "$(${_ pkgs.slurp})" -t ppm - | ${_ pkgs.tesseract5} - - | ${pkgs.wl-clipboard}/bin/wl-copy
    ${_ pkgs.libnotify} "$(${pkgs.wl-clipboard}/bin/wl-paste)"
  '';
in {
  imports = [
    ../graphical/eww
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
    obs-studio.plugins = with pkgs.obs-studio-plugins; [wlrobs];

    swaylock.settings = let
      inherit (colors) xcolors;
    in {
      clock = true;
      effect-blur = "30x3";
      font = "Roboto";
      ignore-empty-password = true;
      image = "${config.xdg.configHome}/wallpaper.png";
      indicator = true;
      bs-hl-color = xcolors.base0E;
      key-hl-color = xcolors.base07;
      inside-clear-color = xcolors.base0B;
      inside-color = xcolors.base0A;
      inside-ver-color = xcolors.base0C;
      inside-wrong-color = xcolors.base08;
      line-color = xcolors.base00;
      ring-color = xcolors.base09;
      separator-color = xcolors.base0F;
    };
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
