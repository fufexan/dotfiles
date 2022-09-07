{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  dependencies = with pkgs; [
    config.wayland.windowManager.hyprland.package
    config.programs.eww.package
    bc
    bluez
    coreutils
    findutils
    gawk
    gnused
    jq
    light
    networkmanager
    playerctl
    procps
    pulseaudio
    ripgrep
    socat
    upower
    wget
    wireplumber
    wofi
  ];
in {
  home.packages = dependencies;

  programs.eww = {
    enable = true;
    package = inputs.eww.packages.${pkgs.system}.eww-wayland;
    configDir = ./.;
  };

  # systemd.user.services.eww = {
  #   Unit = {
  #     Description = "Eww Daemon";
  #     # not yet implemented
  #     # PartOf = ["tray.target"];
  #     PartOf = ["graphical-session.target"];
  #   };
  #   Service = {
  #     Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
  #     ExecStart = "${config.programs.eww.package}/bin/eww daemon --no-daemonize";
  #     Restart = "on-failure";
  #   };
  #   Install.WantedBy = ["graphical-session.target"];
  # };
}
