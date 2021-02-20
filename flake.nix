{
  description = "Introduction to Nix Flakes";

  outputs = { self, nixpkgs }: {
    nixosConfigurations.nixpc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };
  };
}
