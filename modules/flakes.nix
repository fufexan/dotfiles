{ pkgs, ... }:

# enable flakes

{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes ca-references
      flake-registry = /etc/nix/registry.json
    '';
  };
}
