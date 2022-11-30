{
  _inputs,
  inputs,
  self,
  desktopModules,
  sharedModules,
  homeImports,
  ...
}: {
  systems = ["x86_64-linux"];

  flake = {
    overlays.default = import ./overlays.nix _inputs;

    packages.x86_64-linux.iso = inputs.nixos-generators.nixosGenerate {
      format = "iso";
      system = "x86_64-linux";

      modules =
        [
          "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
          {home-manager.users.mihai.imports = homeImports."mihai@io";}
        ]
        ++ desktopModules
        ++ sharedModules;
    };
  };

  perSystem = {pkgs, ...}: {
    packages = self.overlays.default null pkgs;
  };
}
