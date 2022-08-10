inputs: let
  inherit (inputs) self;
  inherit (self.lib) mkHome extraSpecialArgs;

  sharedModules = [
    ../.
    ../shell
  ];

  homeImports = {
    "mihai@io" = sharedModules ++ [./io];
    server = sharedModules ++ [./server];
  };
in {
  inherit homeImports extraSpecialArgs;

  homeConfigurations = {
    "mihai@io" = mkHome {modules = homeImports."mihai@io";};
    "server" = mkHome {modules = homeImports.server;};
  };
}
