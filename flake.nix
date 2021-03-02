{
  description = "Advancing with Nix Flakes";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;

    pipewire = {
      url = "git+https://gitlab.freedesktop.org/pipewire/pipewire";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, pipewire, ... }@inputs: {
    # group modules here for easier passing
    nixosModules = import ./modules;

    # load configs from folder instead of declaring them here
    nixosConfigurations = import ./hosts inputs;
  };
}
