{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    unrar

    # office
    libreoffice

    # messaging
    tdesktop

    # school stuff
    inputs.nix-xilinx.packages.${pkgs.hostPlatform.system}.vivado
    jetbrains.idea-community

    # torrents
    transmission-remote-gtk

    # misc
    libnotify
    xdg-utils

    # productivity
    obsidian
    xournalpp
  ];
}
