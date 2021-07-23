{
  description = "fufexan's NixOS and Home-Manager flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-kak.url = "github:NixOS/nixpkgs/e5920f73965ce9fd69c93b9518281a3e8cb77040";
    master.url = "github:NixOS/nixpkgs";
    fu.url = "github:numtide/flake-utils";
    utils = {
      url = "github:gytis-ivaskevicius/flake-utils-plus/staging";
      inputs.flake-utils.follows = "fu";
    };

    # flakes
    agenix.url = "github:ryantm/agenix";
    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-eval-lsp = {
      url = "github:aaronjanse/nix-eval-lsp";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "fu";
    };

    nur.url = "github:nix-community/NUR";
    osu-nix = {
      url = github:fufexan/osu.nix;
      inputs.utils.follows = "utils";
    };

    rnix-lsp = {
      url = "github:nix-community/rnix-lsp";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "fu";
    };

    snm = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-21_05.follows = "nixpkgs";
      inputs.utils.follows = "fu";
    };

    kakoune-cr = { url = "github:alexherbo2/kakoune.cr"; flake = false; };
    picom-jonaburg = { url = "github:jonaburg/picom"; flake = false; };
  };

  outputs = { self, utils, nixpkgs, ... }@inputs:
    utils.lib.mkFlake {
      inherit self inputs;


      # channel setup

      channels.nixpkgs.overlaysBuilder = channels: [
        inputs.osu-nix.overlays."nixpkgs/wine-tkg"
        inputs.osu-nix.overlays."nixpkgs/winestreamproxy"
        (
          final: prev: {
            inherit (channels.nixpkgs-kak) kakounePlugins;
          }
        )
        self.overlay
      ];

      channelsConfig = { allowUnfree = true; };


      # modules and hosts

      nixosModules = utils.lib.exportModules [
        ./modules/desktop.nix
        ./modules/minimal.nix
        ./modules/security.nix
        ./modules/services.nix
      ];

      hostDefaults.modules = [
        self.nixosModules.minimal
        self.nixosModules.security
        inputs.agenix.nixosModules.age
      ];

      hosts = {
        homesv.modules = with self.nixosModules; [
          ./hosts/homesv
          inputs.snm.nixosModule
          ./modules/mailserver.nix
          services
        ];

        tosh.modules = with self.nixosModules; [
          ./hosts/tosh
          desktop
          inputs.osu-nix.nixosModule
        ];

        kiiro.modules = with self.nixosModules; [
          ./hosts/kiiro
          desktop
          inputs.osu-nix.nixosModule
        ];
      };


      # homes

      homeConfigurations =
        let
          username = "mihai";
          homeDirectory = "/home/mihai";
          system = "x86_64-linux";
          extraSpecialArgs = { inherit inputs; };
          generateHome = inputs.hm.lib.homeManagerConfiguration;
          nixpkgs = {
            config = {
              allowUnfree = true;
              permittedInsecurePackages = [
                "ffmpeg-3.4.8"
              ];
            };
            overlays = [
              self.overlay
              inputs.nur.overlay
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
          full = generateHome {
            inherit system username homeDirectory extraSpecialArgs;
            pkgs = self.pkgs.x86_64-linux.nixpkgs;
            configuration = {
              imports = [ ./home ];
              inherit nixpkgs;
            };
            extraModules = [
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
        };


      # overlays
      overlay = import ./pkgs { inherit inputs; };
      overlays = utils.lib.exportOverlays {
        inherit (self) pkgs inputs;
      };

      # packages
      outputsBuilder = channels: {
        packages = utils.lib.exportPackages self.overlays channels;
      };
    };

  nixConfig = {
    substituters = [ "https://app.cachix.org/cache/fufexan" ];
    trusted-public-keys = [ "fufexan.cachix.org-1:LwCDjCJNJQf5XD2BV+yamQIMZfcKWR9ISIFy5curUsY=" ];
  };
}
