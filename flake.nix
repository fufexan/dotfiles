{
  description = "fufexan's NixOS and Home-Manager flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-kak.url = "github:NixOS/nixpkgs/e5920f73965ce9fd69c93b9518281a3e8cb77040";
    master.url = "github:NixOS/nixpkgs";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus/staging";

    # flakes
    agenix.url = "github:ryantm/agenix";
    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-eval-lsp = {
      url = "github:aaronjanse/nix-eval-lsp";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "utils/flake-utils";
    };

    nur.url = "github:nix-community/NUR";
    osu-nix.url = github:fufexan/osu.nix;

    snm = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "utils/flake-utils";
    };

    # not flakes
    picom-jonaburg = {
      url = "github:jonaburg/picom";
      flake = false;
    };
  };

  outputs = { self, utils, nixpkgs, ... }@inputs:
    utils.lib.systemFlake {
      inherit self inputs;


      # channel setup
      
      channels = {
        nixpkgs.input = inputs.nixpkgs;
        master.input = inputs.master;
        nixpkgs-kak.input = inputs.nixpkgs-kak;
      };

      channels.nixpkgs.overlaysBuilder = channels: [
        (final: prev: {
          inherit (channels.master) quintom-cursor-theme;
          inherit (channels.nixpkgs-kak) kakounePlugins;
        })
      ];

      channelsConfig = { allowUnfree = true; };


      # modules and hosts

      nixosModules = utils.lib.modulesFromList [
        ./modules/desktop.nix
        ./modules/minimal.nix
        ./modules/security.nix
        ./modules/services.nix
      ];

      sharedModules = [
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

        kasshoku = {
          system = "i686-linux";
          modules = with self.nixosModules; [
            ./hosts/kasshoku
            desktop
          ];
        };

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
              self.overlays.generic
              self.overlays.linux
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
                imports = [ ./home/full.nix ];
                inherit nixpkgs;
              };
              extraModules = [
                ./home/modules/files.nix
                ./home/modules/mail.nix
                ./home/modules/media.nix
                ./home/modules/xsession.nix
                ./home/editors/kakoune
              ];
            };
          };


      # overlays

      overlays.generic = import ./overlays;
      overlays.linux = (
        final: prev: {
          picom-jonaburg = prev.picom.overrideAttrs (
            old: {
              src = inputs.picom-jonaburg;
            }
          );
        }
      );

      sharedOverlays = [
        self.overlays.generic
        self.overlays.linux
        inputs.nur.overlay
      ];


      # packages

      outputsBuilder = channels: {
        packages = utils.lib.exporters.fromOverlays self.overlays channels;
      };
    };
}
