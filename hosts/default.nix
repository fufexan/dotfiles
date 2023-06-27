{
  inputs,
  withSystem,
  sharedModules,
  desktopModules,
  homeImports,
  withSystemInputs,
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
          ../modules/pam.nix
          ../modules/howdy
          ../modules/linux-enable-ir-emitter.nix
          inputs.lanzaboote.nixosModules.lanzaboote
          {home-manager.users.mihai.imports = homeImports."mihai@io";}
          {disabledModules = ["security/pam.nix"];}
        ]
        ++ sharedModules
        ++ desktopModules
        ++ (withSystemInputs system);
    };

    rog = inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      modules =
        [
          ./rog
          ../modules/greetd.nix
          ../modules/desktop.nix
          ../modules/gamemode.nix
          {disabledModules = ["programs/hyprland.nix"];}
          {home-manager.users.mihai.imports = homeImports."mihai@rog";}
        ]
        ++ sharedModules
        ++ desktopModules
        ++ (withSystemInputs system);
    };

    kiiro = inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      modules =
        [
          ./kiiro
          {home-manager.users.mihai.imports = homeImports.server;}
        ]
        ++ sharedModules
        ++ (withSystemInputs system);
    };
  });
}
