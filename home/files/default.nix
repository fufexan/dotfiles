{
  colors,
  pkgs,
  ...
}:
# manage files in ~
{
  home.file = {
    ".wayland-session" = {
      text = import ./wayland-session.nix;
      executable = true;
    };

    ".config" = {
      source = ./config;
      recursive = true;
    };
  };
  xdg.configFile = {
    "wayfire.ini".text = import ./wayfire.nix colors;
    "wallpaper.jpg".source = builtins.fetchurl {
      name = "WavesDark.jpg";
      url = "https://raw.githubusercontent.com/catppuccin/wallpapers/main/waves/Waves%20Dark%20Alt%206016x6016.jpg";
      sha256 = "01ncs3p774phgnwai1kvldmfspp36rcpz10aw29808fbrvhfy676";
    };
    "swaylock/config".text = ''
      ignore-empty-password
      clock
      effect-blur=30x3
      font=Roboto
      screenshot
    '';
  };
}
