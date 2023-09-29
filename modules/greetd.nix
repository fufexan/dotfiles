{
  lib,
  pkgs,
  config,
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

    exec "${lib.getExe config.programs.regreet.package} -l debug; swaymsg exit"
  '';
in {
  environment.systemPackages = with pkgs; [
    # theme packages
    (catppuccin-gtk.override {
      accents = ["flamingo"];
      size = "compact";
      variant = "mocha";
    })
    bibata-cursors
    papirus-icon-theme
  ];

  programs.regreet = {
    enable = true;
    package = pkgs.greetd.regreet.overrideAttrs (self: super: rec {
      version = "0.1.1-patched";
      src = pkgs.fetchFromGitHub {
        owner = "rharish101";
        repo = "ReGreet";
        rev = "61d871a0ee5c74230dfef8100d0c9bc75b309203";
        hash = "sha256-PkQTubSm/FN3FXs9vBB3FI4dXbQhv/7fS1rXkVsTAAs=";
      };
      cargoDeps = super.cargoDeps.overrideAttrs (_: {
        inherit src;
        outputHash = "sha256-dR6veXCGVMr5TbCvP0EqyQKTG2XM65VHF9U2nRWyzfA=";
      });

      # temp fix until https://github.com/rharish101/ReGreet/issues/32 is solved
      patches = [../pkgs/regreet.patch];
    });

    settings = {
      background = {
        path = default.wallpaper;
        fit = "Cover";
      };
      GTK = {
        cursor_theme_name = "Bibata-Modern-Classic";
        font_name = "Lexend 9";
        icon_theme_name = "Papirus-Dark";
        theme_name = "Catppuccin-Mocha-Compact-Mauve-Dark";
      };
    };
  };

  programs.sway.enable = true;

  services.greetd.settings.default_session.command =
    "${config.programs.sway.package}/bin/sway --config ${greetdSwayConfig}"
    + (lib.optionalString (config.networking.hostName == "rog") " --unsupported-gpu");

  # unlock GPG keyring on login
  security.pam.services.greetd.enableGnomeKeyring = true;
}
