{
  pkgs,
  inputs,
  ...
}: {
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
    tdesktop

    gnome-calculator
    gnome-control-center

    overskride
    mission-center
    wineWowPackages.wayland

    inputs.nix-matlab.packages.${pkgs.system}.matlab
  ];

  xdg.configFile."matlab/nix.sh".text = "INSTALL_DIR=$XDG_DATA_HOME/matlab/installation";
}
