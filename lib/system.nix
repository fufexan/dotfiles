inputs:

let
  inherit (inputs.nixpkgs) lib;
in
rec {
  supportedSystems = [ "aarch64-linux" "x86_64-linux" ];

  genSystems = f:
    lib.genAttrs supportedSystems (system: f system);

  nixpkgsFor = genSystems (system: overlays: import inputs.nixpkgs {
    inherit system overlays;
  });
}
