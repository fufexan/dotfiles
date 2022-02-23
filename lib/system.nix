inputs:

let
  inherit (inputs.nixpkgs) lib;
in
rec {
  supportedSystems = [ "x86_64-linux" ];

  genSystems = f:
    lib.genAttrs supportedSystems (system: f system);

  nixpkgsFor = genSystems (system: overlays: import inputs.nixpkgs {
    inherit system overlays;
  });
}
