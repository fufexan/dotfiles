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

    sway-git = {
      url = "github:swaywm/sway/1.6-rc2";
      flake = false;
    };
    wlroots-git = {
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
        ./modules/security.nix
        ./modules/services.nix
        ./modules/snd_usb_audio.nix
        ./modules/xorg.nix
      ];

      nixosProfiles = {
        homesv.modules = with self.nixosModules; [
          (import ./hosts/homesv)
          snm.nixosModule
          (import ./modules/mailserver.nix)
          services
        ];

        kiiro.modules = with self.nixosModules; [
          (import ./hosts/kiiro)
          fonts
          pipewire
          snd_usb_audio
          xorg
        ];
      };

      sharedExtraArgs = { inherit inputs; };

      sharedModules = [
        self.nixosModules.configuration
        self.nixosModules.security
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
            nix-zsh-completions = prev.nix-zsh-completions.overrideAttrs
              (old: { src = inputs.nix-zsh-comp; });

            picom-kawase = prev.picom.overrideAttrs (old: {
              src = prev.fetchFromGitHub {
                owner = "tryone144";
                repo = "compton";
                rev = "c67d7d7b2c36f29846c6693a2f39a2e191a2fcc4";
                sha256 = "1y1821islx0cg61z9kshs4mkvcp45bpkmzbll5zpzq84ycnqji2y";
              };
            });
            picom = final.picom-kawase;

            # NOTE: sway 1.5.1 won't build with this for some reason
            #wlroots = prev.wlroots.overrideAttrs (old: {
            #  src = inputs.wlroots-git;
            #  buildInputs = old.buildInputs ++ (with prev; [
            #    libuuid
            #    cmake
            #    xorg.xcbutilrenderutil
            #    xwayland
            #  ]);
            #});

            # broken
            #sway-unwrapped = prev.sway-unwrapped.overrideAttrs (old: {
            #  version = "1.6-rc1";
            #  src = inputs.sway-git;
            #  buildInputs = with prev;
            #    [ cmake wayland-protocols libdrm ] ++ old.buildInputs;
            #});

            #sway-unwrapped = prev.sway-unwrapped.overrideAttrs (old: {
            #  mesonFlags = old.mesonFlags ++ [ "-Dwerror=false" ];
            #  buildInputs = with prev;
            #    [ cmake wayland-protocols libdrm ] ++ old.buildInputs;
            #});
          })
      ];

      supportedSystems = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];

      defaultAppBuilder = channels: utils.lib.replApp channels.nixpkgs;

      packagesBuilder = channels: {
        inherit (channels.nixpkgs) hunter nix-zsh-completions picom-kawase;
      };

      appsBuilder = channels:
        with channels.nixpkgs;
        let mkApp = utils.lib.mkApp;
        in {
          hunter = mkApp {
            drv = hunter;
            exePath = "/bin/hunter";
          };
          picom-kawase = mkApp {
            drv = picom;
            exePath = "/bin/picom";
          };
        };
    };
}
