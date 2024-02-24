{
  imports = [
    ./fonts.nix
    ./home-manager.nix
    # ./qt.nix
    ./xdg.nix
  ];

  programs = {
    # make HM-managed GTK stuff work
    dconf.enable = true;

    kdeconnect.enable = true;

    seahorse.enable = true;
  };
}
