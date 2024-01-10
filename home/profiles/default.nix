{
  self,
  inputs,
  withSystem,
  ...
}: let
  # get these into the module system
  specialArgs = {inherit inputs self;};

  sharedModules = [
    ../.
    {_module.args = specialArgs;}
    inputs.ags.homeManagerModules.default
    inputs.anyrun.homeManagerModules.default
    inputs.hyprland.homeManagerModules.default
    inputs.matugen.nixosModules.default
    inputs.nix-index-db.hmModules.nix-index
    inputs.spicetify-nix.homeManagerModule
    self.nixosModules.theme
  ];

  homeImports = {
    "mihai@io" = [./io] ++ sharedModules;
    "mihai@rog" = [./rog] ++ sharedModules;
    server = [./server] ++ sharedModules;
  };

  inherit (inputs.hm.lib) homeManagerConfiguration;
in {
  # we need to pass this to NixOS' HM module
  _module.args = {inherit homeImports;};

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
  };
}
