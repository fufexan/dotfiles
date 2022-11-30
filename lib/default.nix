inputs:
# personal lib
let
  colors = import ./colors.nix inputs.nixpkgs.lib;
  system = import ./system.nix inputs;
in
  inputs.nixpkgs.lib // colors // system
# adding nixpkgs lib is ugly but easier to keep track of things

