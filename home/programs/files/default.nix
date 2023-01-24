{
  pkgs,
  lib,
  config,
  ...
}:
# manage files in ~
{
  imports = [./nix-index-update-db.nix];

  home.file.".config" = {
    source = ./config;
    recursive = true;
  };
}
