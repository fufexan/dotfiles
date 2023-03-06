{
  _inputs,
  self,
  ...
}: {
  systems = ["x86_64-linux"];

  flake.overlays.default = import ./overlays.nix _inputs;

  perSystem = {pkgs, ...}: {
    packages = self.overlays.default null pkgs;
  };
}
