{
  description = "fufexan's NixOS and Home-Manager flake";

  outputs = {nixpkgs, ...} @ inputs: let
    lib = import ./lib inputs;
    inherit (lib) genSystems;

    overlays.default = import ./pkgs inputs;

    pkgs = genSystems (system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.packageOverrides = pkgs: {
          steam = pkgs.steam.override {
            extraPkgs = pkgs:
              with pkgs; [
                keyutils
                libkrb5
                libpng
                libpulseaudio
                libvorbis
                stdenv.cc.cc.lib
                xorg.libXcursor
                xorg.libXi
                xorg.libXinerama
                xorg.libXScrnSaver
              ];
            extraProfile = "export GDK_SCALE=2";
          };
        };
        overlays = [
          (final: prev: {
            linux_latest_amd_pstate = prev.linuxPackagesFor (prev.linux_latest.override {
              structuredExtraConfig = with prev.lib.kernel; {
                X86_AMD_PSTATE = yes;
              };
              ignoreConfigErrors = true;
            });
          })
        ];
      });
  in {
    inherit lib overlays pkgs;

    # standalone home-manager config
    inherit (import ./home/profiles inputs) homeConfigurations;

    deploy = import ./hosts/deploy.nix inputs;

    # nixos-configs with home-manager
    nixosConfigurations = import ./hosts inputs;

    devShells = genSystems (system: {
      default = inputs.devshell.legacyPackages.${system}.mkShell {
        packages = with pkgs.${system}; [
          alejandra
          git
          inputs.deploy-rs.defaultPackage.${system}
          (overlays.default null pkgs.${system}).repl
        ];
        name = "dots";
      };
    });

    packages =
      # I don't like this
      lib.genAttrs ["x86_64-linux"] (system: overlays.default null pkgs.${system})
      // {aarch64-linux.repl = (overlays.default null pkgs.aarch64-linux).repl;};

    formatter = genSystems (system: pkgs.${system}.alejandra);
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.utils.follows = "fu";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # flakes

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devshell.url = "github:numtide/devshell";

    eww = {
      url = "github:elkowar/eww";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    fu.url = "github:numtide/flake-utils";

    helix.url = "github:helix-editor/helix";

    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "fu";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    nix-colors.url = "github:Misterio77/nix-colors";

    nix-gaming.url = "github:fufexan/nix-gaming";

    nix-matlab = {
      url = "gitlab:doronbehar/nix-matlab";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "fu";
    };

    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    webcord.url = "github:fufexan/webcord-flake";
  };
}
