inputs: _: prev: rec {
  # instant repl with automatic flake loading
  repl = prev.callPackage ./repl {};

  discord-canary = prev.callPackage ./discord.nix {
    pkgs = prev;
    inherit inputs;
    inherit (prev) lib;
  };

  gdb-frontend = prev.callPackage ./gdb-frontend {};

  iso = inputs.nixos-generators.nixosGenerate {
    format = "iso";
    system = "x86_64-linux";

    modules = let
      inherit (import "${inputs.self}/home/profiles" inputs) homeImports;
      inherit (import "${inputs.self}/theme" inputs) default;
    in [
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
      {home-manager.users.mihai.imports = homeImports."mihai@io";}
      {
        _module.args = {inherit inputs default;};
      }
      ../modules/minimal.nix
      ../modules/security.nix
      inputs.agenix.nixosModule
      inputs.hm.nixosModule
      {
        home-manager = {
          extraSpecialArgs = {inherit inputs default;};
          useGlobalPkgs = true;
        };
      }
      inputs.hyprland.nixosModules.default
      inputs.kmonad.nixosModules.default
      inputs.nix-gaming.nixosModules.default
    ];
  };

  tlauncher = prev.callPackage ./tlauncher.nix {};

  waveform = prev.callPackage ./waveform {};

  sway-hidpi = import ./sway-hidpi.nix prev;

  spotifywm = prev.spotifywm.overrideAttrs (old: {
    version = "2022-09-21";
    src = prev.fetchFromGitHub {
      owner = "amurzeau";
      repo = "spotifywm";
      rev = "a2b5efd5439b0404f1836cc9a681417627531a00";
      sha256 = "sha256-AsXqcoqUXUFxTG+G+31lm45gjP6qGohEnUSUtKypew0=";
    };
  });

  spotify-wrapped-wm = import ./spotify prev spotifywm;
}
