{
  description = "fufexan's NixOS and Home-Manager flake";

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    lib = import ./lib inputs;
    inherit (lib) genSystems;

    overlays.default = import ./pkgs inputs;

    pkgs = genSystems (system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
  in {
    inherit lib overlays pkgs;

    # standalone home-manager config
    inherit (import ./home/profiles inputs) homeConfigurations;

    deploy = import ./hosts/deploy.nix inputs;

    # nixos-configs with home-manager
    nixosConfigurations = import ./hosts inputs;

    devShells = genSystems (system: {
      default = inputs.devshell.legacyPackages.${system}.mkShell {
        packages = with pkgs.${system}; [
          alejandra
          git
          inputs.rnix-lsp.defaultPackage.${system}
          inputs.deploy-rs.defaultPackage.${system}
          (overlays.default null pkgs.${system}).repl
        ];
        name = "dots";
      };
    });

    packages = lib.genAttrs ["x86_64-linux"] (system: overlays.default null pkgs.${system});

    formatter = genSystems (system: pkgs.${system}.alejandra);
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.utils.follows = "fu";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # flakes
    devshell.url = "github:numtide/devshell";

    discocss = {
      url = "github:fufexan/discocss/flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "fu";
    };

    emacs-overlay.url = "github:nix-community/emacs-overlay";

    eww = {
      url = "github:elkowar/eww";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.naersk.follows = "naersk";
    };

    fu.url = "github:numtide/flake-utils";

    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
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

    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "fu";
    };

    nix-colors.url = "github:Misterio77/nix-colors";

    nix-gaming.url = "github:fufexan/nix-gaming";

    rnix-lsp = {
      url = "github:nix-community/rnix-lsp";
      inputs.naersk.follows = "naersk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "fu";
    };
    
    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
