{
  pkgs,
  lib,
  config,
  ...
}:
# manage files in ~
{
  imports = [
    ./nix-index-update-db.nix
    ./wlogout.nix
    ./wofi-style.nix
  ];

  home.file.".config" = {
    source = ./config;
    recursive = true;
  };
}
