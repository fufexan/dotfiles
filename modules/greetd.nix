{
  pkgs,
  inputs,
  ...
}: let
  wall = builtins.fetchurl rec {
    name = "wallpaper-${sha256}.png";
    url = "https://9to5mac.com/wp-content/uploads/sites/6/2014/08/yosemite-4.jpg?quality100&strip=all";
    sha256 = "1hvpphvrdnlrdij2armq5zpi5djg2wj7hxhg148cgm9fs9m3z1vq";
  };

  schema = pkgs.gsettings-desktop-schemas;
  datadir = schema: "${schema}/share/gsettings-schemas/${schema.name}";

  # I need to fix this
  configure-gtk = pkgs.writeShellScript "configure-gtk" ''
    export XDG_DATA_DIRS=${datadir schema}:${datadir pkgs.gtk3}:$XDG_DATA_DIRS

    gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Orange-Dark-Compact'
    # gsettings set org.gnome.desktop.interface cursor-theme 'Quintom_Ink'
    # gsettings set org.gnome.desktop.interface font-name 'Roboto'
  '';
in {
  environment.systemPackages = with pkgs; [
    catppuccin-gtk
    greetd.gtkgreet
    quintom-cursor-theme
  ];

  services.greetd = {
    enable = true;
    settings = {
      default_session.command = let
        gtkgreetStyle = pkgs.writeText "greetd-gtkgreet.css" ''
          window {
            background-image: url("${wall}");
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
          exec "${configure-gtk}"
          exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l -s ${gtkgreetStyle}; swaymsg exit"

          bindsym Mod4+shift+e exec swaynag \
            -t warning \
            -m 'What do you want to do?' \
            -b 'Poweroff' 'systemctl poweroff' \
            -b 'Reboot' 'systemctl reboot'
        '';
      in "${inputs.self.packages.${pkgs.system}.sway-hidpi}/bin/sway --config ${greetdSwayConfig}";
    };
  };

  environment.etc."greetd/environments".text = ''
    Hyprland
    sway
    zsh
  '';
}
