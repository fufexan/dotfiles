{ pkgs, nixpkgs, ... }:

# enable flakes

{
  environment.systemPackages = with pkgs; [ coreutils git gnutar ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes ca-references
    '';
    registry.nixpkgs.flake = nixpkgs;
  };
}
