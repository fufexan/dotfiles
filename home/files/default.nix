{ config, colors, ... }:

# manage files in ~

{
  home.file = {
    ".wayland-session" = {
      text = import ./wayland-session.nix config;
      executable = true;
    };

    ".config" = {
      source = ./config;
      recursive = true;
    };

    ".config/wayfire.ini".text = import ./wayfire.nix colors;
  };
}
