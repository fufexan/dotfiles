{pkgs, ...}: {
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    unrar

    # messaging
    tdesktop

    # school stuff
    jetbrains.idea-community

    # torrents
    transmission-remote-gtk

    # misc
    libnotify
    wineWowPackages.wayland
    xdg-utils

    # productivity
    obsidian
    xournalpp
  ];
}
