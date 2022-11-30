inputs: let
  sharedModules = [
    ../.
    ../shell
    {
      _module.args = {
        inherit inputs;
        default = import "${inputs.self}/theme" inputs;
      };
    }
  ];

  homeImports = {
    "mihai@io" = sharedModules ++ [./io];
    server = sharedModules ++ [./server];
  };

  extraSpecialArgs = {
    inherit inputs;
    inherit (import "${inputs.self}/theme" inputs) default;
  };

  pkgs = inputs.self.pkgs.x86_64-linux;
  inherit (inputs.hm.lib) homeConfiguration;
in {
  inherit homeImports;

  homeConfigurations = {
    "mihai@io" = homeConfiguration {
      modules = homeImports."mihai@io";
      inherit pkgs extraSpecialArgs;
    };
    "server" = homeConfiguration {
      modules = homeImports.server;
      inherit pkgs extraSpecialArgs;
    };
  };
}
