{ pkgs, ... }:

{
  home.packages = [ pkgs.helix ];
  home.file.".config/helix/config.toml".text = ''
    [editor]
    line-number = relative
  '';
}
