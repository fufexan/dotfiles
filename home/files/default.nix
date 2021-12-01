{ config, ... }:

# manage files in ~

{
  home.file = {
    ".wayland-session".text = import ./wayland-session.nix { inherit config; };

    ".config" = {
      source = ./config;
      recursive = true;
    };
  };
}
