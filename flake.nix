{
  description = "fufexan's NixOS and Home-Manager flake";

  outputs = { self, utils, nixpkgs, ... }@inputs:
    let
      extraSpecialArgs = {
        inherit inputs self;
        nix-colors = inputs.nix-colors.colorSchemes.horizon-terminal-dark;
      };
    in
    utils.lib.mkFlake
      {
        inherit self inputs;

        # apply overlays to nixpkgs
        channels.nixpkgs.overlaysBuilder = channels: [
          self.overlay
          inputs.devshell.overlay
          inputs.utils.overlay
        ];
        channelsConfig.allowUnfree = true;

        # modules and hosts
        hosts = {
          homesv.modules = [
            ./hosts/homesv
            { home-manager.users.mihai = import ./home/cli.nix; }
          ];

          io.modules = [
            ./hosts/io
            ./modules/desktop.nix
            ./modules/gamemode.nix
            ./modules/gnome.nix
            { home-manager.users.mihai = import ./home/profiles/mihai-io; }
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
            { home-manager.users.mihai = import ./home/cli.nix; }
          ];

          tosh.modules = [
            ./hosts/tosh
            ./modules/desktop.nix
            { home-manager.users.mihai = import ./home/profiles/mihai-tosh; }
          ];
        };

        hostDefaults.modules = [
          ./modules/minimal.nix
          inputs.hm.nixosModule
          inputs.kmonad.nixosModule
          inputs.nix-gaming.nixosModule
          {
            home-manager = {
              inherit extraSpecialArgs;
              useGlobalPkgs = true;
            };
          }
        ];

        # homes
        homeConfigurations =
          let
            configuration = { };
            inherit extraSpecialArgs;
            generateHome = inputs.hm.lib.homeManagerConfiguration;
            homeDirectory = "/home/${username}";
            pkgs = self.pkgs.${system}.nixpkgs;
            system = "x86_64-linux";
            username = "mihai";
          in
          rec {
            # homeConfigurations
            cli = generateHome {
              inherit system username homeDirectory extraSpecialArgs pkgs configuration;
              extraModules = [ ./home/cli.nix ];
            };

            "mihai@kiiro" = cli;

            "mihai@tosh" = generateHome {
              inherit system username homeDirectory extraSpecialArgs pkgs configuration;
              extraModules = [ ./home/profiles/mihai-tosh ];
            };
          };

        # library of functions I use
        lib = import ./lib { inherit (nixpkgs) lib; };

        # overlays
        overlay = import ./pkgs { inherit inputs; };
        overlays = utils.lib.exportOverlays { inherit (self) inputs pkgs; };

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

    nix-colors.url = "github:Misterio77/nix-colors";

    nix-gaming = {
      url = "github:fufexan/nix-gaming/fup-unfree";
      inputs.utils.follows = "utils";
    };

    rnix-lsp = {
      url = "github:nix-community/rnix-lsp";
      inputs.naersk.follows = "naersk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "fu";
    };
  };
}
