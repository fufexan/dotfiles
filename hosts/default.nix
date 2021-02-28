{ nixpkgs, self, ... }@inputs:

let
  inherit (nixpkgs.lib) nixosSystem;

  mkSystem = name: nixpkgs: modules:
    nixpkgs.lib.nixosSystem ({
      extraArgs = inputs;
      system    = "x86_64-linux";
    });
in
{
  homesv = mkSystem "homesv" nixpkgs (with self.nixosModules; [
    configuration services
  ]);
  kiiro  = mkSystem "kiiro"  nixpkgs (with self.nixosModules; [
    configuration fonts services xorg
  ]);
}
