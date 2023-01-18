{
  inputs,
  withSystem,
  module_args,
  ...
}: let
  sharedModules = [
    ../.
    ../shell
    module_args
  ];

  homeImports = {
    "mihai@io" =
      [
        ./io
        inputs.spicetify-nix.homeManagerModule
        inputs.hyprland.homeManagerModules.default
      ]
      ++ sharedModules;
    server = sharedModules ++ [./server];
  };

  inherit (inputs.hm.lib) homeManagerConfiguration;
in {
  imports = [
    {_module.args = {inherit homeImports;};}
  ];

  flake = {
    homeConfigurations = withSystem "x86_64-linux" ({pkgs, ...}: {
      "mihai@io" = homeManagerConfiguration {
        modules = homeImports."mihai@io" ++ module_args;
        inherit pkgs;
      };
      server = homeManagerConfiguration {
        modules = homeImports.server ++ module_args;
        inherit pkgs;
      };
    });
  };
}
