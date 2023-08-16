{
  pkgs,
  lib,
  inputs,
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
    ../programs/eww
    ./anyrun.nix
    ./gtklock.nix
    ./hyprland
    ./sway.nix
    ./swaybg.nix
    ./swayidle.nix
  ];

  programs.eww-hyprland = {
    enable = true;
    # temp fix until https://github.com/NixOS/nixpkgs/pull/249515 lands. after that,
    # eww's nixpkgs has to be updated
    package = inputs.eww.packages.${pkgs.system}.eww-wayland.overrideAttrs (old: {
      nativeBuildInputs = old.nativeBuildInputs ++ [pkgs.wrapGAppsHook];
      buildInputs = lib.lists.remove pkgs.gdk-pixbuf (old.buildInputs ++ [pkgs.librsvg]);
    });
  };

  home.packages = with pkgs; [
    # screenshot
    grim
    slurp

    swaybg

    # utils
    ocrScript
    wf-recorder
    wl-clipboard
    wlogout
    wlr-randr
  ];

  # make stuff work on wayland
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };

  programs.obs-studio.plugins = with pkgs.obs-studio-plugins; [wlrobs];

  # fake a tray to let apps start
  # https://github.com/nix-community/home-manager/issues/2064
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };
}
