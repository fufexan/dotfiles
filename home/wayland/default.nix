{
  pkgs,
  lib,
  self,
  inputs,
  config,
  ...
}:
# Wayland config
let
  # use OCR and copy to clipboard
  ocrScript = let
    inherit (pkgs) grim libnotify slurp tesseract5 wl-clipboard;
    _ = lib.getExe;
  in
    pkgs.writeShellScriptBin "wl-ocr" ''
      ${_ grim} -g "$(${_ slurp})" -t ppm - | ${_ tesseract5} - - | ${wl-clipboard}/bin/wl-copy
      ${_ libnotify} "$(${wl-clipboard}/bin/wl-paste)"
    '';
in {
  imports = [
    ./anyrun
    ./hyprland
    ./swaylock.nix
    ../services/ags
    ../services/eww
    ../services/hyprpaper.nix
    ../services/swayidle.nix
  ];

  programs.eww-hyprland = {
    enable = false;
    package = inputs.eww.packages.${pkgs.system}.eww-wayland;
    colors = builtins.readFile "${self}/home/services/eww/css/colors-${config.programs.matugen.variant}.scss";
  };

  home.packages = with pkgs; [
    # screenshot
    grim
    slurp

    # utils
    ocrScript
    wl-clipboard
    wl-screenrec
    wlogout
    wlr-randr
  ];

  # make stuff work on wayland
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };

  # Create tray target
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };
}
