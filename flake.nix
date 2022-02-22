{
  description = "fufexan's NixOS and Home-Manager flake";

  outputs = { self, nixpkgs, ... }@inputs:
    rec {
      lib = import ./lib inputs;

      overlay = import ./pkgs;

      nixosConfigurations = import ./hosts inputs;

      inherit (import ./home/profiles inputs) homeConfigurations;

      devShell = {
        "x86_64-linux" =
          let
            pkgs = import nixpkgs { system = "x86_64-linux"; overlays = [ inputs.devshell.overlay ]; };
          in

          pkgs.devshell.mkShell {
            packages = with pkgs; [
              git
              nixpkgs-fmt
              inputs.rnix-lsp.defaultPackage."x86_64-linux"
            ];

            name = "dots";
          };
      };
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
