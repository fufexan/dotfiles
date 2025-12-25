{ pkgs, inputs, ... }:
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
    telegram-desktop

    gnome-calculator
    gnome-control-center

    overskride
    resources
    wineWowPackages.wayland

    zotero

    inputs.nix-matlab.packages.${pkgs.stdenv.hostPlatform.system}.matlab
  ];

  xdg.configFile."matlab/nix.sh".text = "INSTALL_DIR=$XDG_DATA_HOME/matlab/installation_2025b";
}
