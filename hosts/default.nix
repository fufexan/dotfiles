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

          {
            home-manager = {
              users.mihai.imports = homeImports."mihai@io";
              extraSpecialArgs = specialArgs;
              backupFileExtension = ".hm-backup";
            };
          }

          inputs.agenix.nixosModules.default
        ];
      };

      ganymede = nixosSystem {
        inherit specialArgs;
        modules = defaults ++ [
          ./ganymede
          "${mod}/hardware/ddcci.nix"

          {
            home-manager = {
              users.mihai.imports = homeImports."mihai@io";
              extraSpecialArgs = specialArgs;
              backupFileExtension = ".hm-backup";
            };
          }
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
              backupFileExtension = ".hm-backup";
            };
          }
        ];
      };
    };
}
