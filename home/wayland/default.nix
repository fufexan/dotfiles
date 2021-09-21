{ pkgs, ... }:

# Wayland config

{
  home.packages = with pkgs; [
    wl-clipboard
  ];
}
