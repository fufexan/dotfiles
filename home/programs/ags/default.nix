{
  pkgs,
  lib,
  config,
  ...
}: let
  dependencies = with pkgs; [
    config.wayland.windowManager.hyprland.package
    bash
    coreutils
    gawk
    procps
    ripgrep
    sassc
  ];

  cfg = config.programs.ags;
in {
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
