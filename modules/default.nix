{inputs, ...}: {
  flake.nixosModules = {
    theme = import ./theme inputs.matugen;
  };
}
