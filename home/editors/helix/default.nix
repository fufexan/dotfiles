{ pkgs, ... }:

{
  home.packages = [ pkgs.helix ];

  home.file.".config/helix/config.toml".source = ./config.toml;
}
