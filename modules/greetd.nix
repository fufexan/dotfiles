{
  pkgs,
  inputs,
  default,
  ...
}:
# greetd display manager
let
  gtkgreetStyle = with default.xcolors;
    pkgs.writeText "greetd-gtkgreet.css" ''
      window {
        background-color: black;
        background-image: url("${default.wallpaper}");
        background-position: center;
        background-repeat: no-repeat;
        background-size: cover;
      }

      #body > box > box > label, #clock {
        color: ${text};
        text-shadow: 0 0 3px ${crust};
      }

      entry {
        background-color: ${base};
        border-radius: 16px;
        box-shadow: 0 0 5px ${crust};
        color: ${text};
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
in {
  environment.systemPackages = with pkgs; [
    # theme packages
    (catppuccin-gtk.override {
      accents = ["mauve"];
      size = "compact";
      variant = "mocha";
    })
    bibata-cursors
    papirus-icon-theme
  ];

  # set gtk theme
  environment.etc."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-cursor-theme-name=Bibata-Modern-Classic
    gtk-cursor-theme-size=24
    gtk-font-name=Roboto
    gtk-icon-theme-name=Papirus-Dark
    gtk-theme-name=Catppuccin-Mocha-Compact-Mauve-Dark
  '';

  services.greetd = {
    enable = true;
    settings.default_session.command = "${inputs.self.packages.${pkgs.hostPlatform.system}.sway-hidpi}/bin/sway --config ${greetdSwayConfig}";
  };

  # selectable options
  environment.etc."greetd/environments".text = ''
    Hyprland
    sway
    zsh
  '';
}
