{ pkgs, ... }:
{
  imports = [
    ./zathura
  ];

  home.packages = with pkgs; [
    libreoffice
    obsidian
    xournalpp
  ];
}
