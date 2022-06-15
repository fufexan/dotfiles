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
        overlays = [
          inputs.devshell.overlay
          inputs.emacs-overlay.overlay
          inputs.powercord.overlay
          overlays.default
        ];
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
      default = pkgs.${system}.devshell.mkShell {
        packages = with pkgs.${system}; [
          alejandra
          git
          inputs.rnix-lsp.defaultPackage.${system}
          inputs.deploy-rs.defaultPackage.${system}
          repl
        ];
        name = "dots";
      };
    });

    packages = lib.genAttrs ["x86_64-linux"] (system: {
      inherit
        (pkgs.${system})
        discord-canary-electron
        gamescope
        gdb-frontend
        hyprland
        repl
        technic-launcher
        tlauncher
        waveform
        ;
    });

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
      url = "github:vaxerski/hyprland";
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

    nix-gaming.url = "github:fufexan/nix-gaming/testing";

    powercord = {
      url = "github:LavaDesu/powercord-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin-discord = {
      url = "github:catppuccin/discord";
      flake = false;
    };
    discord-tweaks = {
      url = "github:NurMarvin/discord-tweaks";
      flake = false;
    };
    powercord-image-tools = {
      url = "github:powerfart-plugins/image-tools";
      flake = false;
    };

    catppuccin-helix = {
      url = "github:catppuccin/helix";
      flake = false;
    };

    rnix-lsp = {
      url = "github:mtoohey31/rnix-lsp/feat/improved-format-edits";
      inputs.naersk.follows = "naersk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "fu";
    };
  };
}
