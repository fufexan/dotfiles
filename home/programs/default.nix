{
  imports = [
    ../shell/nix.nix
    ../terminals/foot.nix
    ./cinny.nix
    ./files
    ./media.nix
    ./git.nix
    ./gtk.nix
    ./kdeconnect.nix
    ./packages.nix
    ./qt.nix
    ./spicetify.nix
    ./xdg.nix
    ./zathura.nix
  ];

  programs = {
    chromium = {
      enable = true;
      commandLineArgs = ["--enable-features=TouchpadOverscrollHistoryNavigation"];
      extensions = [
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";}
        {id = "bkkmolkhemgaeaeggcmfbghljjjoofoh";}
      ];
    };

    firefox = {
      enable = true;
      profiles.mihai = {};
    };
  };

  services.syncthing.enable = true;
}
