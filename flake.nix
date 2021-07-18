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
    osu-nix = {
      url = github:fufexan/osu.nix;
      inputs.utils.follows = "utils/flake-utils";
    };

    rnix-lsp = {
      url = "github:nix-community/rnix-lsp";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils/flake-utils";
    };

    snm = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "utils/flake-utils";
    };

    # not flakes
    kakoune-cr = { url = "github:alexherbo2/kakoune.cr"; flake = false; };
    picom-jonaburg = { url = "github:jonaburg/picom"; flake = false; };
  };

  outputs = { self, utils, nixpkgs, ... }@inputs:
    utils.lib.mkFlake {
      inherit self inputs;


      # channel setup

      channels.nixpkgs.overlaysBuilder = channels: [
        (
          final: prev: {
            inherit (channels.nixpkgs-kak) kakounePlugins;
          }
        )
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
              self.overlays.generic
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
              ./home/modules/x11
              ./home/editors/emacs
              ./home/editors/kakoune
              ./home/editors/neovim
            ];
          };
        };


      # overlays

      overlays.generic = import ./overlays { inherit inputs; };

      sharedOverlays = [
        self.overlays.generic
        inputs.nur.overlay
      ];


      # packages

      outputsBuilder = channels: {
        packages = utils.lib.exportOverlays self.overlays channels;
      };
    };
}
