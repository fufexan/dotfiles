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
        font-family: "Jost *", Roboto, sans-serif;
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

  set_theme = let
    gds = pkgs.gsettings-desktop-schemas;
    gtk = pkgs.gtk3;
  in
    pkgs.writeShellScript "set_sway_theme" ''
      gnome_schema=org.gnome.desktop.interface
      export XDG_DATA_DIRS="${gtk}/share/gsettings-schemas/${gtk.name}:${gds}/share/gsettings-schemas/${gds.name}"

      gsettings set $gnome_schema gtk-theme 'Catppuccin-Mocha-Compact-Mauve-Dark'
      gsettings set $gnome_schema icon-theme 'Papirus-Dark'
      gsettings set $gnome_schema cursor-theme 'Bibata-Modern-Classic'
      gsettings set $gnome_schema cursor-size '24'
      gsettings set $gnome_schema font-name 'Roboto 11'
    '';

  greetdSwayConfig = pkgs.writeText "greetd-sway-config" ''
    exec "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP"
    exec "${set_theme}"
    seat seat0 xcursor_theme Bibata-Modern-Classic 24

    xwayland disable

    bindsym Mod4+shift+e exec swaynag \
      -t warning \
      -m 'What do you want to do?' \
      -b 'Poweroff' 'systemctl poweroff' \
      -b 'Reboot' 'systemctl reboot'

    exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l -s ${gtkgreetStyle}; swaymsg exit"
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

  services.greetd = {
    enable = true;
    settings.default_session.command = "${inputs.self.packages.${pkgs.hostPlatform.system}.sway-hidpi}/bin/sway --config ${greetdSwayConfig}";
  };

  # unlock GPG keyring on login
  security.pam.services.greetd.gnupg.enable = true;

  # selectable options
  environment.etc."greetd/environments".text = ''
    Hyprland
    sway
    zsh
  '';
}
