{
  description = "Advancing with Nix Flakes";

  inputs = {
    # flakes
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    # secrets management
    agenix = {
      url = github:ryantm/agenix;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # miscellaneous
    pipewire = {
      url = "git+https://gitlab.freedesktop.org/pipewire/pipewire";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, pipewire, agenix, ... }@inputs: {
    # group modules here for easier passing
    nixosModules = import ./modules;

    # not sure where to import overlays so I do it everywhere
    nixpkgs.overlays = import ./overlays;
    overlays = import ./overlays;

    # load configs from folder instead of declaring them here
    nixosConfigurations = import ./hosts inputs;
  };
}
