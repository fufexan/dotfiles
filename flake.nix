{
  description = "Advancing with Nix Flakes";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    nixpkgs-pipewire.url =
      github:NixOS/nixpkgs/b012ecaae7a273a9b09adbf608f7bf44374b8869;

    pipewire = {
      url = "git+https://gitlab.freedesktop.org/pipewire/pipewire";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-pipewire, pipewire, ... }@inputs: {
    # group modules here for easier passing
    nixosModules = import ./modules;

    # load configs from folder instead of declaring them here
    nixosConfigurations = import ./hosts inputs;
  };
}
