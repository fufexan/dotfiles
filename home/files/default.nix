{ config, nix-colors, self, ... }:

# manage files in ~

{
  home.file = {
    ".wayland-session" = {
      text = import ./wayland-session.nix { inherit config; };
      executable = true;
    };

    ".config" = {
      source = ./config;
      recursive = true;
    };

    ".config/wayfire.ini".text = import ./wayfire.nix { inherit nix-colors self; };
  };
}
