{ inputs, ... }:

{
  imports = [
    ../.
    ../files
    ../games.nix
    ../media.nix
    ../editors/helix
    inputs.nix-colors.homeManagerModule
  ];
}
