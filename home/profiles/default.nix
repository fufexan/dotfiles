{
  inputs,
  withSystem,
  module_args,
  ...
}: let
  sharedModules = withSystem "x86_64-linux" ({
    inputs',
    self',
    ...
  }: [
    ../.
    ../shell
    module_args
    {_module.args = {inherit inputs' self';};}
    inputs.anyrun.homeManagerModules.default
    inputs.nix-index-db.hmModules.nix-index
    inputs.spicetify-nix.homeManagerModule
    inputs.hyprland.homeManagerModules.default
  ]);

  homeImports = {
    "mihai@io" = [./io] ++ sharedModules;
    "mihai@rog" = [./rog] ++ sharedModules;
    server = [./server] ++ sharedModules;
  };

  inherit (inputs.hm.lib) homeManagerConfiguration;
in {
  imports = [
    # we need to pass this to NixOS' HM module
    {_module.args = {inherit homeImports;};}
  ];

  flake = {
    homeConfigurations = withSystem "x86_64-linux" ({pkgs, ...}: {
      "mihai@io" = homeManagerConfiguration {
        modules = homeImports."mihai@io";
        inherit pkgs;
      };

      "mihai@rog" = homeManagerConfiguration {
        modules = homeImports."mihai@rog";
        inherit pkgs;
      };

      server = homeManagerConfiguration {
        modules = homeImports.server;
        inherit pkgs;
      };
    });

    homeManagerModules.eww-hyprland = import ../programs/eww;
  };
}
