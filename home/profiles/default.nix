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
    inputs.spicetify-nix.homeManagerModule
    inputs.hyprland.homeManagerModules.default
  ];

  homeImports = {
    "mihai@io" = sharedModules ++ [../dunst.nix ../wayland ./io ../editors/neovim];
    "mihai@rog" = sharedModules ++ [../wayland ./rog ../editors/neovim];
    "mihai@tosh" = sharedModules ++ [../wayland ./tosh];
    server = [../cli.nix ./server];
  };
in {
  inherit homeImports extraSpecialArgs;

  homeConfigurations = {
    "mihai@io" = mkHome {modules = homeImports."mihai@io";};
    "mihai@rog" = mkHome {modules = homeImports."mihai@rog";};
    "mihai@tosh" = mkHome {modules = homeImports."mihai@tosh";};
    "server" = mkHome {modules = homeImports.server;};
  };
}
