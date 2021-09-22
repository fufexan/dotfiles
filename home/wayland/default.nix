{ pkgs, ... }:

# Wayland config

{
  home.packages = with pkgs; [
    wl-clipboard
  ];

  programs.firefox.package = pkgs.firefox-wayland;
}
