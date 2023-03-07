{
  lib,
  pkgs,
  config,
  inputs,
  default,
  ...
}:
# greetd display manager
let
  greetdSwayConfig = pkgs.writeText "greetd-sway-config" ''
    exec "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP"
    input "type:touchpad" {
      tap enabled
    }
    seat seat0 xcursor_theme Bibata-Modern-Classic 24

    xwayland disable

    bindsym Mod4+shift+e exec swaynag \
      -t warning \
      -m 'What do you want to do?' \
      -b 'Poweroff' 'systemctl poweroff' \
      -b 'Reboot' 'systemctl reboot'

    exec "${lib.getExe config.programs.regreet.package}; swaymsg exit"
  '';
in {
  imports = [./regreet.nix];
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

  programs.regreet = {
    enable = true;
    package = inputs.self.packages.${pkgs.hostPlatform.system}.regreet;
    settings = {
      background = default.wallpaper;
      background_fit = "Cover";
      GTK = {
        cursor_theme_name = "Bibata-Modern-Classic";
        font_name = "Jost * 12";
        icon_theme_name = "Papirus-Dark";
        theme_name = "Catppuccin-Mocha-Compact-Mauve-Dark";
      };
    };
  };

  services.greetd.settings.default_session.command = "${inputs.self.packages.${pkgs.hostPlatform.system}.sway-hidpi}/bin/sway --config ${greetdSwayConfig}";

  # unlock GPG keyring on login
  security.pam.services.greetd.gnupg.enable = true;
}
