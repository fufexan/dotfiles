inputs:
# personal lib
let
  inherit (inputs.nixpkgs) lib;

  colors = import ./colors.nix lib;
  system = import ./system.nix inputs;
  home = import ./home.nix inputs;
in
  lib // colors // home // system
# adding lib is ugly but easier to keep track of things

