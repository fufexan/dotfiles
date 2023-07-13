{
  inputs,
  withSystem,
  sharedModules,
  homeImports,
  ...
}: {
  flake.nixosConfigurations = withSystem "x86_64-linux" ({
    system,
    self',
    inputs',
    ...
  }: let
    systemInputs = {_module.args = {inherit self' inputs';};};
    inherit (inputs.nixpkgs.lib) nixosSystem;
  in {
    io = nixosSystem {
      inherit system;

      modules =
        [
          ./io
          ../modules/bluetooth.nix
          ../modules/greetd.nix
          ../modules/desktop.nix
          ../modules/gamemode.nix
          ../modules/lanzaboote.nix
          ../modules/power-switcher.nix
          {home-manager.users.mihai.imports = homeImports."mihai@io";}
          systemInputs
        ]
        ++ sharedModules;
    };

    rog = nixosSystem {
      inherit system;

      modules =
        [
          ./rog
          ../modules/bluetooth.nix
          ../modules/greetd.nix
          ../modules/desktop.nix
          ../modules/gamemode.nix
          ../modules/lanzaboote.nix
          ../modules/power-switcher.nix
          {home-manager.users.mihai.imports = homeImports."mihai@rog";}
          systemInputs
        ]
        ++ sharedModules;
    };

    kiiro = nixosSystem {
      inherit system;

      modules =
        [
          ./kiiro
          {home-manager.users.mihai.imports = homeImports.server;}
          systemInputs
        ]
        ++ sharedModules;
    };
  });
}
