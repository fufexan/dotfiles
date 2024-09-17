{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations = let
    # shorten paths
    inherit (inputs.nixpkgs.lib) nixosSystem;

    howdy = inputs.nixpkgs-howdy;

    homeImports = import "${self}/home/profiles";

    mod = "${self}/system";
    # get the basic config to build on top of
    inherit (import mod) laptop;

    # get these into the module system
    specialArgs = {inherit inputs self;};
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
          "${mod}/programs/games.nix"

          "${mod}/network/spotify.nix"
          "${mod}/network/syncthing.nix"

          "${mod}/services/kanata"
          "${mod}/services/gnome-services.nix"
          "${mod}/services/location.nix"

          {
            home-manager = {
              users.mihai.imports = homeImports."mihai@io";
              extraSpecialArgs = specialArgs;
            };
          }

          # enable unmerged Howdy
          {disabledModules = ["security/pam.nix"];}
          "${howdy}/nixos/modules/security/pam.nix"
          "${howdy}/nixos/modules/services/security/howdy"
          "${howdy}/nixos/modules/services/misc/linux-enable-ir-emitter.nix"

          inputs.agenix.nixosModules.default
          inputs.chaotic.nixosModules.default
        ];
    };

    nixos = nixosSystem {
      inherit specialArgs;
      modules = [
        ./wsl
        "${mod}/core/users.nix"
        "${mod}/nix"
        "${mod}/programs/zsh.nix"
        "${mod}/programs/home-manager.nix"
        {
          home-manager = {
            users.mihai.imports = homeImports.server;
            extraSpecialArgs = specialArgs;
          };
        }
      ];
    };
  };
}
