{ config, pkgs, lib, ... }:

{
  imports = [
    # minimal config
    ./modules/minimal.nix
    # graphical session (builds on top of minimal)
    ./modules/graphical.nix
  ];

  # let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.username = "mihai";
  home.homeDirectory = "/home/mihai";
  home.stateVersion = "20.09";

  # install user packages 
  home.packages = with pkgs; [
    # archives
    p7zip
    unrar
    # file converters
    ffmpeg
    # file downloaders
    youtube-dl
    # file managers
    ranger
    # nix tools
    nix-index
    # misc
    exa # ls alternative with colors & icons
    file # info about files
    glxinfo # info about OpenGL
    gotop
    htop # system monitor
    ripgrep # better grep
    tree
    usbutils
  ];
  home.extraOutputsToInstall = [ "doc" "info" "devdoc" ];

  xdg.enable = true;
}
