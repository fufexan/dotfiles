{
  description = "fufexan's NixOS and Home-Manager flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-kak.url = "github:NixOS/nixpkgs/e5920f73965ce9fd69c93b9518281a3e8cb77040";
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

      channels.nixpkgs.input = nixpkgs;

      channelsConfig = { allowUnfree = true; };

      nixosModules = utils.lib.modulesFromList [
        ./modules/desktop.nix
        ./modules/minimal.nix
        ./modules/security.nix
        ./modules/services.nix
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
              configuration = {
                imports = [ ./home/full.nix ];
                inherit nixpkgs;
              };
              extraModules = [
                ./home/modules/files.nix
                ./home/modules/mail.nix
                ./home/modules/media.nix
                ./home/modules/xsession.nix
                ./home/editors/emacs
                ./home/editors/kakoune
                ./home/editors/neovim
              ];
            };
          };

      sharedModules = [
        self.nixosModules.minimal
        self.nixosModules.security
        inputs.agenix.nixosModules.age
        inputs.hm.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];

      overlays.generic = import ./overlays;
      overlays.linux = (
        final: prev: {
          kakounePlugins = inputs.nixpkgs-kak.legacyPackages.x86_64-linux.kakounePlugins;

          picom-jonaburg = prev.picom.overrideAttrs (
            old: {
              src = inputs.picom-jonaburg;
            }
          );
          picom = final.picom-jonaburg;
        }
      );

      sharedOverlays = [
        self.overlays.generic
        self.overlays.linux
        inputs.nur.overlay
      ];

      # waitig for fup fix
      #outputsBuilder = channels: {
      #  packages = {
      #    inherit (channels.nixpkgs)
      #      kakoune-cr
      #      picom-jonaburg
      #      ;
      #  };
      #};

      packages = {
        x86_64-linux = {
          kakoune-cr = self.pkgs.x86_64-linux.nixpkgs.kakoune-cr;
          picom-jonaburg = self.pkgs.x86_64-linux.nixpkgs.picom-jonaburg;
        };
        i686-linux = {
          kakoune-cr = self.pkgs.i686-linux.nixpkgs.kakoune-cr;
          picom-jonaburg = self.pkgs.i686-linux.nixpkgs.picom-jonaburg;
        };
        aarch64-linux = {
          picom-jonaburg = self.pkgs.aarch64-linux.nixpkgs.picom-jonaburg;
        };
      };
    };
}
