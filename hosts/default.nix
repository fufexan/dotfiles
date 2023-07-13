{
  inputs,
  withSystem,
  sharedModules,
  desktopModules,
  homeImports,
  ...
}: {
  flake.nixosConfigurations = withSystem "x86_64-linux" ({
    system,
    self',
    inputs',
    ...
  }: let
    systemInputs = [{_module.args = {inherit self' inputs';};}];
  in {
    io = inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      modules =
        [
          ./io
          ../modules/greetd.nix
          ../modules/desktop.nix
          ../modules/gamemode.nix
          ../modules/power-switcher.nix
          inputs.lanzaboote.nixosModules.lanzaboote
          {home-manager.users.mihai.imports = homeImports."mihai@io";}
        ]
        ++ sharedModules
        ++ desktopModules
        ++ systemInputs;
    };

    rog = inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      modules =
        [
          ./rog
          ../modules/greetd.nix
          ../modules/desktop.nix
          ../modules/gamemode.nix
          ../modules/power-switcher.nix
          {home-manager.users.mihai.imports = homeImports."mihai@rog";}
        ]
        ++ sharedModules
        ++ desktopModules
        ++ systemInputs;
    };

    kiiro = inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      modules =
        [
          ./kiiro
          {home-manager.users.mihai.imports = homeImports.server;}
        ]
        ++ sharedModules
        ++ systemInputs;
    };
  });
}
