{
  pkgs,
  inputs,
  default,
  ...
}:
# greetd display manager
{
  environment.systemPackages = with pkgs; [
    # theme packages
    (catppuccin-gtk.override {size = "compact";})
    bibata-cursors
    papirus-icon-theme

    greetd.gtkgreet
  ];

  # set gtk theme
  environment.etc."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-cursor-theme-name=Bibata-Modern-Classic
    gtk-cursor-theme-size=24
    gtk-font-name=Roboto
    gtk-icon-theme-name=Papirus-Dark
    gtk-theme-name=Catppuccin-Orange-Dark-Compact
  '';

  services.greetd = {
    enable = true;
    settings = {
      default_session.command = let
        gtkgreetStyle = pkgs.writeText "greetd-gtkgreet.css" ''
          window {
            background-image: url("${default.wallpaper}");
            background-position: center;
            background-repeat: no-repeat;
            background-size: cover;
            background-color: black;
          }

          #body > box > box > label {
            text-shadow: 0 0 3px #1e1e2e;
            color: #f5e0dc;
          }

          entry {
            color: #f5e0dc;
            background: rgba(30, 30, 46, 0.8);
            border-radius: 16px;
            box-shadow: 0 0 5px #1e1e2e;
          }

          #clock {
            color: #f5e0dc;
            text-shadow: 0 0 3px #1e1e2e;
          }

          .text-button { border-radius: 16px; }
        '';
        greetdSwayConfig = pkgs.writeText "greetd-sway-config" ''
          exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l -s ${gtkgreetStyle}; swaymsg exit"
          bindsym Mod4+shift+e exec swaynag \
            -t warning \
            -m 'What do you want to do?' \
            -b 'Poweroff' 'systemctl poweroff' \
            -b 'Reboot' 'systemctl reboot'
          seat seat0 xcursor_theme Bibata-Modern-Classic 24
          exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP
        '';
      in "${inputs.self.packages.${pkgs.system}.sway-hidpi}/bin/sway --config ${greetdSwayConfig}";
      # in "${pkgs.dbus}/bin/dbus-run-session ${pkgs.cage}/bin/cage -s -- ${pkgs.greetd.gtkgreet} -l -s ${gtkgreetStyle}";
    };
  };

  # selectable options
  environment.etc."greetd/environments".text = ''
    Hyprland
    sway
    zsh
  '';
}
