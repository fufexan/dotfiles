{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./nh.nix
    ./nixpkgs.nix
    ./substituters.nix
  ];

  # we need git for flakes
  environment.systemPackages = [ pkgs.git ];

  nix =
    let
      flakeInputs = lib.filterAttrs (_: v: lib.isType "flake" v) inputs;
    in
    {
      package = pkgs.lix;

      # extra builders to offload work onto
      # don't set a machine as a builder to itself (throws warnings)
      buildMachines = lib.filter (x: x.hostName != config.networking.hostName) [
        {
          hostName = "ganymede";
          systems = [ "x86_64-linux" ];
          maxJobs = 16;
          protocol = "ssh-ng";
          supportedFeatures = [
            "nixos-test"
            "benchmark"
            "kvm"
            "big-parallel"
          ];
        }
      ];

      distributedBuilds = true;

      # pin the registry to avoid downloading and evaling a new nixpkgs version every time
      registry = lib.mapAttrs (_: v: { flake = v; }) flakeInputs;

      # set the path for channels compat
      nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

      settings = {
        auto-optimise-store = true;
        builders-use-substitutes = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        flake-registry = "/etc/nix/registry.json";

        # for direnv GC roots
        keep-derivations = true;
        keep-outputs = true;

        trusted-users = [
          "root"
          "@wheel"
        ];

        accept-flake-config = false;
      };
    };
}
