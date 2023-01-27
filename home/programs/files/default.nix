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
  ];

  home.file.".config" = {
    source = ./config;
    recursive = true;
  };
}
