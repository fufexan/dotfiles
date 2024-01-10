{
  self,
  inputs,
  homeImports,
  default,
  ...
}: {
  flake.nixosConfigurations = let
    # shorten paths
    inherit (inputs.nixpkgs.lib) nixosSystem;
    howdy = inputs.nixpkgs-howdy;
    mod = "${self}/system";

    # get the basic config to build on top of
    inherit (import "${self}/system") desktop laptop;

    # get these into the module system
    specialArgs = {inherit inputs self default;};
  in {
    io = nixosSystem {
      inherit specialArgs;
      modules =
        laptop
        ++ [
          ./io
          "${mod}/core/lanzaboote.nix"

          "${mod}/programs/gamemode.nix"
          "${mod}/programs/hyprland.nix"
          "${mod}/programs/steam.nix"

          "${mod}/network/spotify.nix"
          "${mod}/network/syncthing.nix"

          "${mod}/services/kmonad"
          "${mod}/services/gnome-services.nix"
          "${mod}/services/location.nix"

          {home-manager.users.mihai.imports = homeImports."mihai@io";}

          # enable unmerged Howdy
          {disabledModules = ["security/pam.nix"];}
          "${howdy}/nixos/modules/security/pam.nix"
          "${howdy}/nixos/modules/services/security/howdy"
          "${howdy}/nixos/modules/services/misc/linux-enable-ir-emitter.nix"

          inputs.agenix.nixosModules.default
        ];
    };

    rog = nixosSystem {
      inherit specialArgs;
      modules =
        laptop
        ++ [
          ./rog
          "${self}/system/core/lanzaboote.nix"
          "${self}/system/programs/gamemode.nix"

          "${self}/system/programs/hyprland.nix"
          "${self}/system/programs/steam.nix"

          {home-manager.users.mihai.imports = homeImports."mihai@rog";}
        ];
    };

    kiiro = nixosSystem {
      inherit specialArgs;
      modules =
        desktop
        ++ [
          ./kiiro
          {home-manager.users.mihai.imports = homeImports.server;}
        ];
    };
  };
}
