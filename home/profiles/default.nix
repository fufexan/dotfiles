inputs: let
  inherit (inputs) self;
  inherit (self.lib) mkHome extraSpecialArgs;

  sharedModules = [
    ../.
    ../files
    ../shell
    ../games.nix
    ../media.nix
    ../editors/helix
    inputs.discocss.hmModule
  ];

  homeImports = {
    "mihai@io" = sharedModules ++ [../wayland ./mihai-io ../editors/neovim];
    "mihai@rog" = sharedModules ++ [../wayland ./mihai-rog ../editors/neovim];
    "mihai@tosh" = sharedModules ++ [../wayland ./mihai-tosh];
    server = [../cli.nix];
  };
in {
  inherit homeImports extraSpecialArgs;

  homeConfigurations = {
    "mihai@io" = mkHome {
      username = "mihai";
      extraModules = homeImports."mihai@io";
    };

    "mihai@rog" = mkHome {
      username = "mihai";
      extraModules = homeImports."mihai@rog";
    };

    "mihai@tosh" = mkHome {
      username = "mihai";
      extraModules = homeImports."mihai@tosh";
    };

    "server" = mkHome {
      username = "mihai";
      extraModules = homeImports.server;
    };
  };
}
