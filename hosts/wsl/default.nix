{ inputs, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];
  wsl = {
    enable = true;
    defaultUser = "mihai";
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
