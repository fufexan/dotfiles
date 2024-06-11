{pkgs, ...}: {
  imports = [
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    libreoffice
    obsidian
    rnote
    xournalpp
  ];
}
