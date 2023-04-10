{
  self,
  inputs,
  ...
}: {
  systems = ["x86_64-linux"];

  flake.overlays.default = import ./overlays.nix;

  perSystem = {pkgs, ...}: {
    packages = self.overlays.default inputs null pkgs;
  };
}
