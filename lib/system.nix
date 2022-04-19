inputs: let
  inherit (inputs.nixpkgs) lib;
in rec {
  supportedSystems = ["aarch64-linux" "x86_64-linux"];

  genSystems = lib.genAttrs supportedSystems;

  nixpkgsFor = genSystems (system: overlays:
    import inputs.nixpkgs {
      inherit system overlays;
    });
}
