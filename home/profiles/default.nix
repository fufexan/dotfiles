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
        inputs.nix-index-db.hmModules.nix-index
        inputs.spicetify-nix.homeManagerModule
      ]
      ++ sharedModules;
    "mihai@rog" =
      [
        ./rog
        inputs.nix-index-db.hmModules.nix-index
        inputs.spicetify-nix.homeManagerModule
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
      "mihai@rog" = homeManagerConfiguration {
        modules = homeImports."mihai@rog" ++ module_args;
        inherit pkgs;
      };
      server = homeManagerConfiguration {
        modules = homeImports.server ++ module_args;
        inherit pkgs;
      };
    });

    homeManagerModules.eww-hyprland = import ../programs/eww;
  };
}
