{ config, pkgs, ... }:

# rofi config

{
  programs = {
    rofi = {
      enable = true;
      package = pkgs.rofi.override { plugins = [ pkgs.rofi-emoji ]; };
      theme = ./general.rasi;
    };

    rofi.pass = {
      enable = true;
      extraConfig = ''
        URL_field='url';
        USERNAME_field='user';
      '';
      stores = [ "$HOME/.local/share/password-store" ];
    };
  };

  # also add the layouts
  home.file.".local/share/rofi/layouts" = {
    source = ./layouts;
    recursive = true;
  };
}
