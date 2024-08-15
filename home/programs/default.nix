{pkgs, ...}: {
  imports = [
    ./anyrun
    ./browsers/chromium.nix
    ./browsers/firefox.nix
    ./media
    ./gtk.nix
    ./office
    ./qt.nix
  ];

  home.packages = with pkgs; [
    tdesktop

    gnome-calculator
    gnome.gnome-control-center

    overskride
    mission-center
    wineWowPackages.wayland
  ];
}
