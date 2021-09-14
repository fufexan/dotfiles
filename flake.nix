{
  description = "fufexan's NixOS and Home-Manager flake";

  outputs = { self, utils, nixpkgs, ... }@inputs:
    let
      hmModules = {
        desktop = [
          ./home
          ./home/profiles/mihai-kiiro
          ./home/files.nix
          ./home/games.nix
          ./home/media.nix
          ./home/nix.nix
          ./home/x11
          ./home/editors/emacs/doom.nix
          ./home/editors/kakoune
          ./home/editors/neovim
          inputs.nix-doom-emacs.hmModule
        ];
      };
    in
    utils.lib.mkFlake
      {
        inherit self inputs;

        # apply overlays to nixpkgs
        channels.nixpkgs.overlaysBuilder = channels: [
          (final: prev: { inherit (channels.nixpkgs-kak) kakounePlugins; })
          self.overlay
          inputs.devshell.overlay
          inputs.powercord.overlay
          inputs.utils.overlay
        ];
        channelsConfig.allowUnfree = true;

        # modules and hosts
        hosts = {
          homesv.modules = [
            ./hosts/homesv
            inputs.snm.nixosModule
            { home-manager.users.mihai = import ./home/cli.nix; }
          ];

          tosh.modules = [
            ./hosts/tosh
            ./modules/desktop.nix
            { home-manager.users.mihai.imports = hmModules.desktop; }
          ];

          kiiro.modules = [
            ./hosts/kiiro
            ./modules/desktop.nix
            ./modules/gamemode.nix
            ./modules/gnome.nix
            { home-manager.users.mihai.imports = hmModules.desktop; }
          ];
        };

        hostDefaults.modules = [
          ./modules/minimal.nix
          ./modules/security.nix
          inputs.agenix.nixosModules.age
          inputs.hm.nixosModule
          inputs.kmonad.nixosModule
          inputs.nix-gaming.nixosModule
          {
            home-manager = {
              extraSpecialArgs = { inherit inputs self; };
              useGlobalPkgs = true;
            };
          }
        ];

        # homes
        homeConfigurations =
          let
            configuration = { };
            extraSpecialArgs = { inherit inputs self; };
            generateHome = inputs.hm.lib.homeManagerConfiguration;
            homeDirectory = "/home/${username}";
            pkgs = self.pkgs.${system}.nixpkgs;
            system = "x86_64-linux";
            username = "mihai";
          in
          {
            # homeConfigurations
            cli = generateHome {
              inherit system username homeDirectory extraSpecialArgs pkgs configuration;
              extraModules = [ ./home/cli.nix ];
            };

            "mihai@kiiro" = generateHome {
              inherit system username homeDirectory extraSpecialArgs pkgs configuration;
              extraModules = hmModules.desktop;
            };

            "mihai@tosh" = generateHome {
              inherit system username homeDirectory extraSpecialArgs pkgs configuration;
              extraModules = hmModules.tosh;
            };
          };

        # overlays
        overlay = import ./pkgs { inherit inputs; };
        overlays = utils.lib.exportOverlays { inherit (self) pkgs inputs; };

        # packages
        outputsBuilder = channels: {
          packages = utils.lib.exportPackages self.overlays channels;
          devShell = channels.nixpkgs.devshell.mkShell {
            packages = with channels.nixpkgs; [ nixpkgs-fmt rnix-lsp ];
            name = "dots";
          };
        };
      };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-kak.url = "github:NixOS/nixpkgs/e5920f73965ce9fd69c93b9518281a3e8cb77040";

    utils = {
      url = "github:gytis-ivaskevicius/flake-utils-plus/release-1.2.0-without-deprecated-code";
      inputs.flake-utils.follows = "fu";
    };

    # flakes
    agenix.url = "github:ryantm/agenix";

    devshell.url = "github:numtide/devshell";

    fu.url = "github:numtide/flake-utils";

    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kmonad = {
      url = "github:kmonad/kmonad/d130553134f0fb2254852e719a06bc36dce58441?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "fu";
    };

    naersk = {
      url = "github:nmattia/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-doom-emacs = {
      url = "github:vlaci/nix-doom-emacs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "fu";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.utils.follows = "utils";
    };

    nobbz.url = "github:NobbZ/nixos-config/overhaul";
    unstable.follows = "nobbz/unstable";

    powercord = {
      url = "github:LavaDesu/powercord-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
    };

    rnix-lsp = {
      url = "github:nix-community/rnix-lsp";
      inputs.naersk.follows = "naersk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "fu";
    };

    snm = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-21_05.follows = "nixpkgs";
      inputs.utils.follows = "fu";
    };

    discord-tweaks = { url = "github:NurMarvin/discord-tweaks"; flake = false; };
    paperwm = { url = "github:paperwm/PaperWM/next-release"; flake = false; };
    picom = { url = "github:yshui/picom"; flake = false; };
    vim-horizon = { url = "github:ntk148v/vim-horizon"; flake = false; };
  };
}
