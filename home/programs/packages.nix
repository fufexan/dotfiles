{pkgs, ...}: {
  home.packages = with pkgs; [
    # messaging
    tdesktop

    # misc
    libnotify
    xdg-utils

    # productivity
    obsidian
    xournalpp
  ];
}
