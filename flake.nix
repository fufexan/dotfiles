{
  description = "fufexan's NixOS and Home-Manager flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-kak.url = "github:NixOS/nixpkgs/e5920f73965ce9fd69c93b9518281a3e8cb77040";

    fu.url = "github:numtide/flake-utils";
    utils = {
      url = "github:gytis-ivaskevicius/flake-utils-plus/1.3.0";
      inputs.flake-utils.follows = "fu";
    };

    # flakes
    agenix.url = "github:ryantm/agenix";

    devshell.url = "github:numtide/devshell";

    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    naersk = {
      url = "github:nmattia/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.utils.follows = "utils";
    };

    nobbz.url = "github:NobbZ/nixos-config/overhaul";
    unstable.follows = "nobbz/unstable";

    powercord = {
      url = "github:LavaDesu/powercord-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
    };

    rnix-lsp = {
      url = "github:nix-community/rnix-lsp";
      inputs.naersk.follows = "naersk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "fu";
    };

    snm = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-21_05.follows = "nixpkgs";
      inputs.utils.follows = "fu";
    };

    discord-tweaks = { url = "github:NurMarvin/discord-tweaks"; flake = false; };
    kakoune-cr = { url = "github:alexherbo2/kakoune.cr"; flake = false; };
    paperwm = { url = "github:paperwm/PaperWM/next-release"; flake = false; };
    picom = { url = "github:yshui/picom"; flake = false; };
    vim-horizon = { url = "github:ntk148v/vim-horizon"; flake = false; };
  };

  outputs = { self, utils, nixpkgs, ... }@inputs:
    utils.lib.mkFlake {
      inherit self inputs;


      # channel setup

      # apply overlays to nixpkgs
      channels.nixpkgs.overlaysBuilder = channels: [
        (
          final: prev: {
            inherit (channels.nixpkgs-kak) kakounePlugins;
          }
        )
        self.overlay
        inputs.devshell.overlay
        inputs.powercord.overlay
        inputs.utils.overlay
      ];

      channelsConfig = { allowUnfree = true; };


      # modules and hosts

      nixosModules = utils.lib.exportModules [
        ./modules/desktop.nix
        ./modules/minimal.nix
        ./modules/security.nix
      ];

      hostDefaults.modules = [
        self.nixosModules.minimal
        self.nixosModules.security
        inputs.agenix.nixosModules.age
        inputs.hm.nixosModule
        {
          home-manager = {
            extraSpecialArgs = { inherit inputs self; };
            useGlobalPkgs = true;
          };
        }
      ];

      hosts = {
        homesv.modules = with self.nixosModules; [
          ./hosts/homesv
          inputs.snm.nixosModule
          { home-manager.users.mihai = import ./home/cli.nix; }
        ];

        tosh.modules = with self.nixosModules; [
          ./hosts/tosh
          desktop
          inputs.nix-gaming.nixosModule
          { home-manager.users.mihai = import ./home; }
        ];

        kiiro.modules = with self.nixosModules; [
          ./hosts/kiiro
          desktop
          inputs.nix-gaming.nixosModule
          {
            home-manager.users.mihai.imports = [
              ./home
              ./home/profiles/mihai-kiiro
              ./home/files.nix
              ./home/games.nix
              ./home/media.nix
              ./home/nix.nix
              ./home/x11
              ./home/editors/emacs
              ./home/editors/kakoune
              ./home/editors/neovim
            ];
          }
        ];
      };


      # homes

      homeConfigurations =
        let
          username = "mihai";
          homeDirectory = "/home/mihai";
          system = "x86_64-linux";
          extraSpecialArgs = { inherit inputs self; };
          generateHome = inputs.hm.lib.homeManagerConfiguration;
          nixpkgs = {
            config = { allowUnfree = true; };
            overlays = [
              self.overlays."nixpkgs/kakoune-cr"
              inputs.utils.overlay
              inputs.powercord.overlay
            ];
          };
        in
          {
            # homeConfigurations
            cli = generateHome {
              inherit system username homeDirectory extraSpecialArgs;
              configuration = {
                imports = [ ./home/cli.nix ];
                inherit nixpkgs;
              };
            };

            "mihai@kiiro" = generateHome {
              inherit system username homeDirectory extraSpecialArgs;
              pkgs = self.pkgs.x86_64-linux.nixpkgs;
              configuration = {
                imports = [ ./home ];
                inherit nixpkgs;
              };
              extraModules = [
                ./home/profiles/mihai-kiiro
                ./home/files.nix
                ./home/games.nix
                ./home/media.nix
                ./home/nix.nix
                ./home/mail.nix
                ./home/x11
                ./home/editors/emacs
                ./home/editors/kakoune
                ./home/editors/neovim
              ];
            };

            "mihai@tosh" = generateHome {
              inherit system username homeDirectory extraSpecialArgs;
              pkgs = self.pkgs.x86_64-linux.nixpkgs;
              configuration = {
                imports = [ ./home ];
                inherit nixpkgs;
              };
              extraModules = [
                ./home/profiles/mihai-tosh
                ./home/files.nix
                ./home/media.nix
                ./home/nix.nix
                ./home/x11
                ./home/editors/emacs
                ./home/editors/kakoune
              ];
            };
          };

      # overlays
      overlay = import ./pkgs { inherit inputs; };
      overlays = utils.lib.exportOverlays {
        inherit (self) pkgs inputs;
      };

      # packages
      outputsBuilder = channels: {
        packages = utils.lib.exportPackages self.overlays channels;
        devShell = channels.nixpkgs.devshell.mkShell {
          packages = with channels.nixpkgs; [ nixpkgs-fmt rnix-lsp ];
          name = "dots";
        };
      };
    };
}
