{ pkgs, nixpkgs, ... }:

# enable flakes

{
  # use flakes and flake registry
  nix = {
    # enable flakes
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes ca-references
      flake-registry = /etc/nix/registry.json
    '';
    # pin nixpkgs to the commit the system was built from
    registry.nixpkgs.flake = nixpkgs;
  };
}
