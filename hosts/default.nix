{
  inputs,
  withSystem,
  sharedModules,
  desktopModules,
  homeImports,
  ...
}: {
  flake.nixosConfigurations = withSystem "x86_64-linux" ({system, ...}: {
    io = inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      modules =
        [
          ./io
          ../modules/greetd.nix
          ../modules/desktop.nix
          ../modules/gamemode.nix
          ../modules/howdy
          ../modules/linux-enable-ir-emitter.nix
          {home-manager.users.mihai.imports = homeImports."mihai@io";}
          inputs.waveforms-flake.nixosModule
        ]
        ++ sharedModules
        ++ desktopModules;
    };

    kiiro = inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      modules =
        [
          ./kiiro
          {home-manager.users.mihai.imports = homeImports.server;}
        ]
        ++ sharedModules;
    };
  });
}
