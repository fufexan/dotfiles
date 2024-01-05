{
  pkgs,
  self,
  ...
}:
# Wayland config
{
  imports = [
    ./hyprland
    ./swaylock.nix
    ../programs/anyrun
    ../services/ags
    ../services/hyprpaper.nix
    ../services/polkit-agent.nix
    ../services/swayidle.nix
  ];

  home.packages = with pkgs; [
    # screenshot
    grim
    slurp

    # utils
    self.packages.${pkgs.system}.wl-ocr
    wl-clipboard
    wl-screenrec
    wlogout
    wlr-randr
  ];

  # make stuff work on wayland
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };

  # Create tray target
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };
}
