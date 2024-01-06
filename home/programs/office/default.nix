{pkgs, ...}: {
  imports = [
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    obsidian
    xournalpp
  ];
}
