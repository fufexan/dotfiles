inputs: let
  inherit (inputs) self;
  inherit (self.lib) mkHome extraSpecialArgs;

  sharedModules = [
    ../.
    ../files
    ../shell
  ];

  homeImports = {
    "mihai@io" = sharedModules ++ [./io];
    server = [../cli.nix ./server];
  };
in {
  inherit homeImports extraSpecialArgs;

  homeConfigurations = {
    "mihai@io" = mkHome {modules = homeImports."mihai@io";};
    "server" = mkHome {modules = homeImports.server;};
  };
}
