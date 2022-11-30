{
  description = "fufexan's NixOS and Home-Manager flake";

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    lib = import ./lib inputs;
    inherit (lib) genSystems pkgs;
  in {
    inherit lib pkgs;
    overlays.default = import ./pkgs inputs;

    # standalone home-manager config
    inherit (import ./home/profiles inputs) homeConfigurations;

    # nixos-configs with home-manager
    nixosConfigurations = import ./hosts inputs;

    devShells = genSystems (system: {
      default = inputs.devshell.legacyPackages.${system}.mkShell {
        packages = with pkgs.${system}; [
          alejandra
          git
          (self.overlays.default null pkgs.${system}).repl
        ];
        name = "dots";
      };
    });

    packages =
      # I don't like this
      lib.genAttrs ["x86_64-linux"] (system: self.overlays.default null pkgs.${system})
      // {aarch64-linux.repl = (self.overlays.default null pkgs.aarch64-linux).repl;};

    formatter = genSystems (system: pkgs.${system}.alejandra);
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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

    helix.url = "github:SoraTenshi/helix/experimental";

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

    nix-gaming.url = "github:fufexan/nix-gaming";

    nix-matlab = {
      url = "gitlab:doronbehar/nix-matlab";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-xilinx = {
      url = "gitlab:doronbehar/nix-xilinx";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
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

    waveforms-flake = {
      url = "github:liff/waveforms-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    webcord.url = "github:fufexan/webcord-flake";
  };
}
