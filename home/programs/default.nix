{ pkgs, ... }:
{
  imports = [
    ./anyrun
    ./browsers/chromium.nix
    ./browsers/firefox.nix
    ./browsers/zen.nix
    ./media
    ./gtk.nix
    ./office
    ./qt.nix
  ];

  home.packages = with pkgs; [
    halloy
    signal-desktop
    tdesktop

    gnome-calculator
    gnome-control-center

    overskride
    resources
    wineWowPackages.wayland

    zotero
  ];
}
