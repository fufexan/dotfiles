{
  config,
  pkgs,
  lib,
  ...
}: let
  dependencies = with pkgs; [
    config.wayland.windowManager.hyprland.package
    cfg.package
    bash
    blueberry
    bluez
    brillo
    coreutils
    dbus
    findutils
    gawk
    gnome.gnome-control-center
    gnused
    imagemagick
    jaq
    jc
    libnotify
    networkmanager
    pavucontrol
    playerctl
    procps
    pulseaudio
    ripgrep
    socat
    udev
    upower
    util-linux
    wget
    wireplumber
    wlogout
  ];

  reload_script = pkgs.writeShellScript "reload_eww" ''
    windows=$(eww windows | rg '\*' | tr -d '*')

    systemctl --user restart eww.service

    echo $windows | while read -r w; do
      eww open $w
    done
  '';

  cfg = config.programs.eww-hyprland;
in {
  options.programs.eww-hyprland = {
    enable = lib.mkEnableOption "eww Hyprland config";

    package = lib.mkOption {
      type = with lib.types; nullOr package;
      default = pkgs.eww-wayland;
      defaultText = lib.literalExpression "pkgs.eww-wayland";
      description = "Eww package to use.";
    };

    autoReload = lib.mkOption {
      type = lib.types.bool;
      default = false;
      defaultText = lib.literalExpression "false";
      description = "Whether to restart the eww daemon and windows on change.";
    };

    colors = lib.mkOption {
      type = with lib.types; nullOr lines;
      default = null;
      defaultText = lib.literalExpression "null";
      description = ''
        SCSS file with colors defined in the same way as Catppuccin colors are,
        to be used by eww.

        Defaults to Catppuccin Mocha.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];

    # remove nix files
    xdg.configFile."eww" = {
      source = lib.cleanSourceWith {
        filter = name: _type: let
          baseName = baseNameOf (toString name);
        in
          !(lib.hasSuffix ".nix" baseName) && (baseName != "_colors.scss");
        src = lib.cleanSource ./.;
      };

      # links each file individually, which lets us insert the colors file separately
      recursive = true;

      onChange =
        if cfg.autoReload
        then reload_script.outPath
        else "";
    };

    # colors file
    xdg.configFile."eww/css/_colors.scss".text =
      if cfg.colors != null
      then cfg.colors
      else (builtins.readFile ./css/_colors.scss);

    systemd.user.services.eww = {
      Unit = {
        Description = "Eww Daemon";
        # not yet implemented
        # PartOf = ["tray.target"];
        PartOf = ["graphical-session.target"];
      };
      Service = {
        Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
        ExecStart = "${cfg.package}/bin/eww daemon --no-daemonize";
        Restart = "on-failure";
      };
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
