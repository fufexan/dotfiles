{
  description = "fufexan's NixOS and Home-Manager flake";

  outputs = { self, utils, nixpkgs, ... }@inputs:
    let
      hmModules = rec {
        shared = [
          ./home
          ./home/files
          ./home/games.nix
          ./home/media.nix
          ./home/editors/helix
        ];

        io = shared ++ [
          ./home/profiles/mihai-io
          ./home/wayland
          # for games
          ./home/x11
        ];
        kiiro = shared ++ [
          ./home/profiles/mihai-kiiro
          ./home/x11
        ];
        tosh = shared ++ [ ./home/profiles/mihai-tosh ];
      };
    in
    utils.lib.mkFlake
      {
        inherit self inputs;

        # apply overlays to nixpkgs
        channels.nixpkgs.overlaysBuilder = channels: [
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

          io.modules = [
            ./hosts/io
            ./modules/desktop.nix
            ./modules/gamemode.nix
            #./modules/gnome.nix
            ./modules/school.nix
            { home-manager.users.mihai.imports = hmModules.io; }
          ];

          #iso = {
          #  builder = nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem;
          #  modules = [
          #    ./modules/iso.nix
          #    {
          #      home-manager.users.mihai.imports = [
          #        ./home/cli.nix
          #        ./home/editors/neovim
          #      ];
          #    }
          #  ];
          #};

          kiiro.modules = [
            ./hosts/kiiro
            ./modules/desktop.nix
            ./modules/gamemode.nix
            ./modules/gnome.nix
            { home-manager.users.mihai.imports = hmModules.kiiro; }
          ];

          tosh.modules = [
            ./hosts/tosh
            ./modules/desktop.nix
            { home-manager.users.mihai.imports = hmModules.tosh; }
          ];
        };

        hostDefaults.modules = [
          ./modules/minimal.nix
          inputs.hm.nixosModule
          inputs.kmonad.nixosModule
          inputs.nix-gaming.nixosModule
          {
            home-manager = {
              extraSpecialArgs = {
                inherit inputs self;
                colors = import ./home/colors.nix;
              };
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
        overlays = utils.lib.exportOverlays { inherit (self) pkgs; inputs = (builtins.removeAttrs inputs [ "neovitality" ]); };

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

    utils = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
      inputs.flake-utils.follows = "fu";
    };

    # flakes
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

    neovitality = {
      url = "github:vi-tality/neovitality";
      inputs = {
        flake-utils.follows = "fu";
        devshell.follows = "devshell";
      };
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.utils.follows = "utils";
    };

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
    picom = { url = "github:yshui/picom"; flake = false; };
  };
}
