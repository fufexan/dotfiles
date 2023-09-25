{
  lib,
  theme,
  ...
}: {
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

  # _module.args.theme.variant = lib.mkDefault "dark";
  specialisation = {
    light.configuration._module.args.theme = lib.mkForce (theme // {variant = "light";});
    dark.configuration._module.args.theme = lib.mkForce (theme // {variant = "dark";});
  };
}
