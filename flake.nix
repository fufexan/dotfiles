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

    wlroots-src = {
      url = "github:danvd/wlroots-eglstreams";
      flake = false;
    };

    #pipewire = {
    #  url = "git+https://gitlab.freedesktop.org/pipewire/pipewire";
    #  flake = false;
    #};
  };

  outputs = { self, utils, nixpkgs, agenix, ... }@inputs:
    let pkgs = self.pkgs.nixpkgs;
    in utils.lib.systemFlake {
      inherit self inputs;

      channels.nixpkgs.input = nixpkgs;

      nixosModules = import ./modules;

      channelsConfig = { allowUnfree = true; };

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

      sharedOverlays = [
        #(final: prev:
        #  with prev; {
        #    inherit (inputs) wlroots-src;

        #    wlroots = prev.wlroots.overrideAttrs (old: {
        #      src = inputs.wlroots-src;
        #      buildInputs = old.buildInputs ++ (with prev; [
        #        libuuid
        #        cmake
        #        xorg.xcbutilrenderutil
        #        xwayland
        #      ]);
        #    });
        #    sway-unwrapped = prev.sway-unwrapped.overrideAttrs (old: {
        #      mesonFlags = old.mesonFlags ++ [ "-Dwerror=false" ];
        #      buildInputs = old.buildInputs ++ [ prev.cmake prev.wlroots ];
        #    });
        #  })
      ];

      sharedModules = [
        self.nixosModules.configuration
        self.nixosModules.flakes
        agenix.nixosModules.age
        nixpkgs.nixosModules.notDetected # add nixos hardware
        { nix = utils.lib.nixDefaultsFromInputs inputs; }
      ];
    };
}
