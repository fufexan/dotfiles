{
  description = "Advancing with Nix Flakes";

  inputs = {
    nixpkgs.url =
      "github:NixOS/nixpkgs/29b0d4d0b600f8f5dd0b86e3362a33d4181938f9";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-wayland = {
      url = "github:colemickens/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wlroots-src = {
      url = "github:danvd/wlroots-eglstreams";
      flake = false;
    };

    pipewire = {
      type = "gitlab";
      host = "gitlab.freedesktop.org";
      owner = "pipewire";
      repo = "pipewire";
      rev = "6324298bc5a716bb301918cfef7f31045e211883";
      flake = false;
    };
  };

  outputs = { self, utils, nixpkgs, agenix, home-manager, ... }@inputs:
    utils.lib.systemFlake {
      inherit self inputs;

      channels.nixpkgs.input = nixpkgs;

      nixosModules = import ./modules;

      channelsConfig = {
        allowUnfree = true;
        permittedInsecurePackages = [ "openssl-1.0.2u" ];
      };

      nixosProfiles = {
        homesv.modules = with self.nixosModules; [
          (import ./hosts/homesv)
          services
        ];

        kiiro = {
          extraArgs = inputs;
          modules = with self.nixosModules; [
            (import ./hosts/kiiro)
            fonts
            pipewire
            services
            snd_usb_audio
            wayland
            xorg
          ];
        };
      };

      overlay = import ./overlays;

      packagesFunc = channels: {
        inherit (channels.nixpkgs)
        lightcord;
      };

      sharedOverlays = [
        self.overlay
        (final: prev:
          with prev; {
            inherit (inputs) wlroots-src;

            picom = prev.picom.overrideAttrs (old: {
              src = prev.fetchFromGitHub {
                owner = "tryone144";
                repo = "compton";
                rev = "c67d7d7b2c36f29846c6693a2f39a2e191a2fcc4";
                sha256 = "1y1821islx0cg61z9kshs4mkvcp45bpkmzbll5zpzq84ycnqji2y";
              };
            });

            #wlroots = prev.wlroots.overrideAttrs (old: {
            #  src = inputs.wlroots-src;
            #  buildInputs = old.buildInputs ++ (with prev; [
            #    libuuid
            #    cmake
            #    xorg.xcbutilrenderutil
            #    xwayland
            #  ]);
            #});
            #sway-unwrapped = prev.sway-unwrapped.overrideAttrs (old: {
            #  mesonFlags = old.mesonFlags ++ [ "-Dwerror=false" ];
            #  buildInputs = old.buildInputs ++ [ prev.cmake prev.wlroots ];
            #});
          })
      ];

      sharedModules = [
        self.nixosModules.configuration
        self.nixosModules.flakes
        agenix.nixosModules.age
        home-manager.nixosModules.home-manager
        { home-manager.useGlobalPkgs = true; }
        { nix = utils.lib.nixDefaultsFromInputs inputs; }
      ];
    };
}
