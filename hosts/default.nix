{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations =
    let
      # shorten paths
      inherit (inputs.nixpkgs.lib) nixosSystem;

      homeImports = import "${self}/home/profiles";

      hm = profile: {
        home-manager = {
          users.mihai.imports = profile;
          extraSpecialArgs = specialArgs;
          backupFileExtension = ".hm-backup";
        };
      };

      mod = "${self}/system";

      defaults = import mod;

      # get these into the module system
      specialArgs = { inherit inputs self; };
    in
    {
      io = nixosSystem {
        inherit specialArgs;
        modules = defaults ++ [
          ./io
          "${mod}/core/lanzaboote.nix"

          (hm homeImports.main)
        ];
      };

      ganymede = nixosSystem {
        inherit specialArgs;
        modules = defaults ++ [
          ./ganymede
          "${mod}/hardware/ddcci.nix"

          (hm homeImports.main)
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
          (hm homeImports.server)
        ];
      };
    };
}
