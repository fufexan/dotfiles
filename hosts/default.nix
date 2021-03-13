{ nixpkgs, self, agenix, ... }@inputs:

let
  inherit (nixpkgs.lib) nixosSystem;

  mkSystem = name: nixpkgs: modules:
    nixpkgs.lib.nixosSystem ( rec {
      extraArgs = inputs;
      system    = "x86_64-linux";
      modules = [
        (./. + "/${name}") # add local dir modules
        agenix.nixosModules.age # add agenix modules
        nixpkgs.nixosModules.notDetected # add nixos hardware
        {
          nixpkgs.pkgs = import nixpkgs { overlays = [
          (final: prev: {
            wlroots = prev.wlroots.overrideAttrs (old: {
              src = prev.fetchFromGithub {
                owner = "danvd";
                repo = "wlroots-eglstreams";
                rev = "5e570dc6f5d5d4c9f65c21c3994d0b9ab14e9752";
                sha256 = "0frgd9kqps40qj10bd6sim813v0kwsfy046ja53kbzash3pp78pq";
              };
            });
          }) ];
          inherit system;
        };
        }
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
    wayland
    xorg
  ]);
}
