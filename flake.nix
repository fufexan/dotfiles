{
  description = "Advancing with Nix Flakes";

  inputs = {
    nixpkgs.url =
      "github:NixOS/nixpkgs/29b0d4d0b600f8f5dd0b86e3362a33d4181938f9";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    # flakes
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gytis = {
      url = "github:gytis-ivaskevicius/nixfiles";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "hm";
      inputs.utils.follows = "utils";
    };

    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snm = {
      url =
        "gitlab:simple-nixos-mailserver/nixos-mailserver/7d53263b5a13bd476ed9f177d5a48d7b6feffecb";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # not flakes
    alacritty-ligatures = {
      url = "github:zenixls2/alacritty/ligature";
      flake = false;
    };

    nix-zsh-comp = {
      url =
        "github:spwhitt/nix-zsh-completions/939c48c182e9d018eaea902b1ee9d00a415dba86";
      flake = false;
    };

    pipewire-git = {
      type = "gitlab";
      host = "gitlab.freedesktop.org";
      owner = "pipewire";
      repo = "pipewire";
      rev = "6324298bc5a716bb301918cfef7f31045e211883";
      flake = false;
    };

    wlroots-src = {
      url = "github:danvd/wlroots-eglstreams";
      flake = false;
    };
  };

  outputs = { self, utils, nixpkgs, agenix, gytis, hm, snm, ... }@inputs:
    utils.lib.systemFlake {
      inherit self inputs;

      channels.nixpkgs.input = nixpkgs;

      channelsConfig = { allowUnfree = true; };

      nixosModules = utils.lib.modulesFromList [
        ./modules/configuration.nix
        ./modules/fonts.nix
        ./modules/mailserver.nix
        ./modules/pipewire.nix
        ./modules/services.nix
        ./modules/snd_usb_audio.nix
        ./modules/wayland.nix
        ./modules/xorg.nix
      ];

      nixosProfiles = {
        homesv.modules = with self.nixosModules; [
          (import ./hosts/homesv)
          (snm.nixosModule (import ./modules/mailserver.nix))
          services
        ];

        kiiro.modules = with self.nixosModules; [
          (import ./hosts/kiiro)
          fonts
          pipewire
          snd_usb_audio
          wayland
          xorg
        ];
      };

      packagesBuilder = channels: { inherit (channels.nixpkgs) hunter; };

      sharedExtraArgs = { inherit inputs; };

      sharedModules = [
        self.nixosModules.configuration
        agenix.nixosModules.age
        hm.nixosModules.home-manager
        { home-manager.useGlobalPkgs = true; }
        utils.nixosModules.saneFlakeDefaults
      ];

      overlay = import ./overlays;

      sharedOverlays = [
        self.overlay
        gytis.overlay
        (final: prev:
          with prev; {
            inherit (inputs) wlroots-src;

            nix-zsh-completions = prev.nix-zsh-completions.overrideAttrs
              (old: { src = inputs.nix-zsh-comp; });

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
          })
      ];
    };
}
