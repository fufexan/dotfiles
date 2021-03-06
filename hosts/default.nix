{ nixpkgs, self, ... }@inputs:

let
  inherit (nixpkgs.lib) nixosSystem;

  mkSystem = name: nixpkgs: modules:
    nixpkgs.lib.nixosSystem ({
      extraArgs = inputs;
      system    = "x86_64-linux";
      modules = [
        (./. + "/${name}")
        nixpkgs.nixosModules.notDetected
      ] ++ modules;
    });
in
{
  homesv = mkSystem "homesv" nixpkgs (with self.nixosModules; [
    configuration services
  ]);
  kiiro  = mkSystem "kiiro"  nixpkgs (with self.nixosModules; [
    configuration fonts pipewire services snd_usb_audio xorg
  ]);
}
