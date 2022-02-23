{
  description = "fufexan's NixOS and Home-Manager flake";

  outputs = { self, nixpkgs, ... }@inputs:
    let
      lib = import ./lib inputs;
      inherit (lib) genSystems;

      overlay = import ./pkgs;

      pkgs = genSystems (system:
        import nixpkgs {
          inherit system;
          overlays = [
            inputs.devshell.overlay
            overlay
          ];
          config.allowUnfree = true;
        });
    in
    {
      inherit lib overlay pkgs;

      # standalone home-manager config
      inherit (import ./home/profiles inputs) homeConfigurations;

      # nixos-configs with home-manager
      nixosConfigurations = import ./hosts inputs;

      devShell = genSystems (system:
        pkgs.${system}.devshell.mkShell {
          packages = with pkgs.${system}; [
            git
            nixpkgs-fmt
            inputs.rnix-lsp.defaultPackage.${system}
            repl
          ];
          name = "dots";
        });

      packages = genSystems (system: {
        inherit (pkgs.${system})
          repl
          waveform;
      });
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # flakes
    devshell.url = "github:numtide/devshell";

    fu.url = "github:numtide/flake-utils";

    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "fu";
    };

    naersk = {
      url = "github:nmattia/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:Misterio77/nix-colors";

    nix-gaming.url = "github:fufexan/nix-gaming";

    rnix-lsp = {
      url = "github:nix-community/rnix-lsp";
      inputs.naersk.follows = "naersk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "fu";
    };
  };
}
