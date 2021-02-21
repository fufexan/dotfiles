{
  description = "Introduction to Nix Flakes";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # latest pipewire
    pipewire = {
      url = "git+https://gitlab.freedesktop.org/pipewire/pipewire";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, pipewire, ... }@inputs: {
    nixosConfigurations.nixpc = nixpkgs.lib.nixosSystem {
      # extraArgs passes whatever's in the set to the modules
      extraArgs = { inherit inputs; };
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };
  };
}
