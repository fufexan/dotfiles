{
  description = "Advancing with Nix Flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-kak.url =
      "github:NixOS/nixpkgs/e5920f73965ce9fd69c93b9518281a3e8cb77040";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus/staging";

    # flakes
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snm = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs";
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
        ./modules/configuration.nix
        ./modules/fonts.nix
        ./modules/mailserver.nix
        ./modules/pipewire.nix
        ./modules/security.nix
        ./modules/services.nix
        ./modules/xorg.nix
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
            fonts
            pipewire
            xorg
          ];
        };
        kiiro.modules = with self.nixosModules; [
          ./hosts/kiiro
          fonts
          pipewire
          xorg
        ];
      };

      homeConfigurations = let
        username = "mihai";
        homeDirectory = "/home/mihai";
        system = "x86_64-linux";
        generateHome = inputs.hm.lib.homeManagerConfiguration;
        nixpkgs = {
          config = { allowUnfree = true; };
          overlays =
            [ self.overlays.generic self.overlays.linux inputs.nur.overlay ];
        };
      in {
        # homeConfigurations
        cli = generateHome {
          inherit system username homeDirectory;
          configuration = { config, pkgs, ... }: {
            imports = [ ./home/cli.nix ];
            inherit nixpkgs;
          };
        };
        full = generateHome {
          inherit system username homeDirectory;
          configuration = { config, pkgs, ... }: {
            imports = [ ./home/full.nix ];
            inherit nixpkgs;
          };
        };
      };

      sharedModules = [
        self.nixosModules.configuration
        self.nixosModules.security
        inputs.agenix.nixosModules.age
        inputs.hm.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
        utils.nixosModules.saneFlakeDefaults
      ];

      overlays.generic = import ./overlays;
      overlays.linux = (final: prev: {
        kakounePlugins =
          inputs.nixpkgs-kak.legacyPackages.x86_64-linux.kakounePlugins;

        picom-jonaburg =
          prev.picom.overrideAttrs (old: { src = inputs.picom-jonaburg; });
        picom = final.picom-jonaburg;
      });

      sharedOverlays =
        [ self.overlays.generic self.overlays.linux inputs.nur.overlay ];

      packagesBuilder = channels: {
        inherit (channels.nixpkgs) hunter shellac-server;
      };

      packages = {
        x86_64-linux = {
          picom-jonaburg = self.pkgs.x86_64-linux.nixpkgs.picom-jonaburg;
          wine-osu = self.pkgs.x86_64-linux.nixpkgs.wine-osu;
        };
        i686-linux = {
          picom-jonaburg = self.pkgs.i686-linux.nixpkgs.picom-jonaburg;
          wine-osu = self.pkgs.i686-linux.nixpkgs.wine-osu;
        };
        aarch64-linux = {
          picom-jonaburg = self.pkgs.aarch64-linux.nixpkgs.picom-jonaburg;
        };
      };

      appsBuilder = channels:
        with channels.nixpkgs;
        let mkApp = utils.lib.mkApp;
        in {
          hunter = mkApp {
            drv = hunter;
            exePath = "/bin/hunter";
          };
        };
    };
}
