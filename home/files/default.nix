{ config, ... }:

# manage files in ~

{
  home.file = {
    ".wayland-session".text = import ./wayland-session.nix { inherit config; };

    ".local/share/fonts" = {
      source = ./fonts;
      recursive = true;
    };

    ".config" = {
      source = ./config;
      recursive = true;
    };

    ".local/bin" = {
      source = ./bin;
      recursive = true;
    };
  };
}
