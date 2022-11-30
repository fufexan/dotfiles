inputs: let
  inherit (inputs) self;
  inherit (self.lib) extraSpecialArgs;

  sharedModules = [
    ../.
    ../shell
  ];

  homeImports = {
    "mihai@io" = sharedModules ++ [./io];
    server = sharedModules ++ [./server];
  };

  inherit (inputs.hm.lib) homeConfiguration;
in {
  inherit homeImports extraSpecialArgs;

  homeConfigurations = {
    "mihai@io" = homeConfiguration {
      modules = homeImports."mihai@io";
      pkgs = inputs.self.pkgs.x86_64-linux;
      inherit extraSpecialArgs;
    };
    "server" = homeConfiguration {
      modules = homeImports.server;
      pkgs = inputs.self.pkgs.x86_64-linux;
      inherit extraSpecialArgs;
    };
  };
}
