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

    snm = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # not flakes
    picom-jonaburg = {
      url = "github:jonaburg/picom";
      flake = false;
    };

    wlroots-git = {
      url = "github:danvd/wlroots-eglstreams";
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
          (import ./hosts/homesv)
          inputs.snm.nixosModule
          (import ./modules/mailserver.nix)
          services
        ];

        kasshoku = {
          system = "i686-linux";
          modules = with self.nixosModules; [
            (import ./hosts/kasshoku)
            fonts
            pipewire
            xorg
          ];
        };
        kiiro.modules = with self.nixosModules; [
          (import ./hosts/kiiro)
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

      overlay = import ./overlays;

      sharedOverlays = [
        self.overlay
        (final: prev:
          with prev; {

            picom = final.picom-jonaburg;
            picom-jonaburg =
              prev.picom.overrideAttrs (old: { src = inputs.picom-jonaburg; });

            #wlroots = prev.wlroots.overrideAttrs (old: {
            #  src = inputs.wlroots-git;
            #  buildInputs = old.buildInputs ++ (with prev; [
            #    libuuid
            #    cmake
            #    xorg.xcbutilrenderutil
            #    xwayland
            #  ]);
            #});
          })
      ];

      supportedSystems = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];

      packagesBuilder = channels: {
        inherit (channels.nixpkgs) hunter picom-jonaburg;
      };

      appsBuilder = channels:
        with channels.nixpkgs;
        let mkApp = utils.lib.mkApp;
        in {
          hunter = mkApp {
            drv = hunter;
            exePath = "/bin/hunter";
          };
          picom-jonaburg = mkApp {
            drv = picom-jonaburg;
            exePath = "/bin/picom";
          };
        };
    };
}
