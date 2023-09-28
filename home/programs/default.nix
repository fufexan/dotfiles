{
  lib,
  pkgs,
  theme,
  ...
}: let
  colorschemePath = "/org/gnome/desktop/interface/color-scheme";
  dconf = "${pkgs.dconf}/bin/dconf";

  dconfDark = lib.hm.dag.entryAfter [] ''
    ${dconf} write ${colorschemePath} "'prefer-dark'"
  '';
  dconfLight = lib.hm.dag.entryAfter [] ''
    ${dconf} write ${colorschemePath} "'prefer-light'"
  '';
in {
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

  # set dark as default theme
  home.activation = {inherit dconfDark;};

  # light/dark specialisations
  specialisation = {
    light.configuration = {
      _module.args.theme = lib.mkForce (theme // {variant = "light";});
      home.activation = {inherit dconfLight;};
    };
    dark.configuration = {
      _module.args.theme = lib.mkForce (theme // {variant = "dark";});
      home.activation = {inherit dconfDark;};
    };
  };
}
