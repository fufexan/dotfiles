{
  description = "Advancing with Nix Flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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

      sharedModules = [
        self.nixosModules.configuration
        self.nixosModules.security
        inputs.agenix.nixosModules.age
        inputs.hm.nixosModules.home-manager
        { home-manager.useGlobalPkgs = true; }
        utils.nixosModules.saneFlakeDefaults
      ];

      overlays.unix = import ./overlays;
      overlays.linux = (final: prev: {
        picom-jonaburg =
          prev.picom.overrideAttrs (old: { src = inputs.picom-jonaburg; });
        picom = final.picom-jonaburg;
      });

      sharedOverlays =
        [ self.overlays.unix self.overlays.linux inputs.nur.overlay ];

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
