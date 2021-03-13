{
  description = "Advancing with Nix Flakes";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/29b0d4d0b600f8f5dd0b86e3362a33d4181938f9;
    utils.url = github:gytis-ivaskevicius/flake-utils-plus;

    agenix = {
      url = github:ryantm/agenix;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wlroots-src = {
      url = github:danvd/wlroots-eglstreams;
      flake = false;
    };

    #pipewire = {
    #  url = "git+https://gitlab.freedesktop.org/pipewire/pipewire";
    #  flake = false;
    #};
  };

  outputs = { self, utils, nixpkgs, agenix, ... }@inputs:
    let
      pkgs = self.pkgs.nixpkgs;
    in
    utils.lib.systemFlake{
      inherit self inputs;

      pkgs.nixpkgs.input = nixpkgs;

      # group modules here for easier passing
      nixosModules = import ./modules;

      pkgsConfig = {
        allowUnfree = true;
      };

      nixosProfiles = {

        homesv.modules = with self.nixosModules; [
          (import ./hosts/homesv)
          configuration
          flakes
          services
        ];

        kiiro.modules = with self.nixosModules; [
          (import ./hosts/kiiro)
          configuration
          flakes
          fonts
          pipewire
          services
          snd_usb_audio
          wayland
          xorg
        ];
      };

      overlay = import ./overlays;

      sharedOverlays = [
        self.overlay
        (final: prev: with prev; {
          inherit (inputs) wlroots-src;

          #wlroots = prev.wlroots.overrideAttrs (old: {
          #  src = prev.fetchFromGitHub {
          #    owner = "danvd";
          #    repo = "wlroots-eglstreams";
          #    rev = "5e570dc6f5d5d4c9f65c21c3994d0b9ab14e9752";
          #    sha256 = "sha256-QgMeU7yJ5Nfi0mw2GeMX/IBjr5RBmmnn4NKellSpEHU=";
          #  };
          #});
        })
      ];

      sharedModules = [
        agenix.nixosModules.age # add agenix modules
        nixpkgs.nixosModules.notDetected # add nixos hardware
        { nix = utils.lib.nixDefaultsFromInputs inputs; }
      ];

    };
}

