{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  dependencies = with pkgs; [
    config.wayland.windowManager.hyprland.package
    bash
    coreutils
    dart-sass
    gawk
    gnome.gnome-control-center
    imagemagick
    overskride
    procps
    ripgrep
    wlogout
  ];

  cfg = config.programs.ags;
in {
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  programs.ags.enable = true;

  systemd.user.services.ags = {
    Unit = {
      Description = "Aylur's Gtk Shell";
      PartOf = [
        "tray.target"
        "graphical-session.target"
      ];
    };
    Service = {
      Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
      ExecStart = "${cfg.package}/bin/ags";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
