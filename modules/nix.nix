{
  config,
  pkgs,
  inputs,
  inputs',
  lib,
  self,
  ...
}: {
  environment.systemPackages = [
    # we need git for flakes
    pkgs.git
    inputs'.nh.packages.default
  ];
  environment.variables.FLAKE = "/home/mihai/Documents/code/dotfiles";

  nix = {
    # extra builders to offload work onto
    # don't set a machine as a builder to itself (throws warnings)
    buildMachines = lib.filter (x: x.hostName != config.networking.hostName) [
      {
        system = "aarch64-linux";
        sshUser = "root";
        sshKey = "/etc/ssh/ssh_host_ed25519_key";
        maxJobs = 4;
        hostName = "arm-server";
        supportedFeatures = ["nixos-test" "benchmark" "kvm" "big-parallel"];
      }
    ];
    distributedBuilds = true;

    # auto garbage collect
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    # pin the registry to avoid downloading and evaling a new nixpkgs version every time
    registry = lib.mapAttrs (_: v: {flake = v;}) inputs;

    # set the path for channels compat
    nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = ["nix-command" "flakes"];
      flake-registry = "/etc/nix/registry.json";

      # for direnv GC roots
      keep-derivations = true;
      keep-outputs = true;

      substituters = [
        "https://nix-community.cachix.org"
        "https://helix.cachix.org"
        "https://fufexan.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
        "fufexan.cachix.org-1:LwCDjCJNJQf5XD2BV+yamQIMZfcKWR9ISIFy5curUsY="
      ];

      trusted-users = ["root" "@wheel"];
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (
        _: prev: {
          steam = prev.steam.override {
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

          greetd =
            prev.greetd
            // {
              regreet = prev.greetd.regreet.overrideAttrs (oldAttrs: rec {
                version = "0.1.1-patched";
                src = prev.fetchFromGitHub {
                  owner = "rharish101";
                  repo = "ReGreet";
                  rev = "61d871a0ee5c74230dfef8100d0c9bc75b309203";
                  hash = "sha256-PkQTubSm/FN3FXs9vBB3FI4dXbQhv/7fS1rXkVsTAAs=";
                };
                cargoDeps = oldAttrs.cargoDeps.overrideAttrs (_: {
                  inherit src;
                  outputHash = "sha256-dR6veXCGVMr5TbCvP0EqyQKTG2XM65VHF9U2nRWyzfA=";
                });

                patches = [../pkgs/regreet.patch];
              });
            };

          clightd = prev.clightd.overrideAttrs (old: {
            version = "5.9";
            src = prev.fetchFromGitHub {
              owner = "FedeDP";
              repo = "clightd";
              rev = "e273868cb728b9fd0f36944f6b789997e6d74323";
              hash = "sha256-0NYWEJNVDfp8KNyWVY8LkvKIQUTq2MGvKUGcuAcl82U=";
            };
          });
        }
      )
    ];
  };
}
