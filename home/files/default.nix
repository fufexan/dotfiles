{ config, ... }:

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
  };
}
