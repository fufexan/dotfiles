{inputs, ...}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];
  # nh default flake
  environment.variables.FLAKE = "/home/mihai/Documents/code/dotfiles";

  wsl = {
    enable = true;
    defaultUser = "mihai";
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
