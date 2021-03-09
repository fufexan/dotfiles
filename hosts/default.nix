{ nixpkgs, self, agenix, ... }@inputs:

let
  inherit (nixpkgs.lib) nixosSystem;

  mkSystem = name: nixpkgs: modules:
    nixpkgs.lib.nixosSystem ({
      extraArgs = inputs;
      system    = "x86_64-linux";
      modules = [
        (./. + "/${name}") # add local dir modules
        agenix.nixosModules.age # add agenix modules
        nixpkgs.nixosModules.notDetected # add nixos hardware
      ] ++ modules; # add modules defined elsewhere (in flake.nix)
    });
in
{
  homesv = mkSystem "homesv" nixpkgs (with self.nixosModules; [
    configuration
    flakes
    services 
    agenix.nixosModules.age
  ]);
  kiiro  = mkSystem "kiiro"  nixpkgs (with self.nixosModules; [
    configuration
    flakes
    fonts
    pipewire
    services
    snd_usb_audio
    xorg
  ]);
}
