{
  _inputs,
  inputs,
  default,
  ...
}: let
  module_args = {
    _module.args = {
      inputs = _inputs;
      inherit default;
    };
  };
in {
  imports = [
    {
      _module.args = {
        inherit module_args;

        sharedModules = [
          {home-manager.useGlobalPkgs = true;}
          inputs.agenix.nixosModules.default
          inputs.hm.nixosModule
          module_args
          ./core.nix
          ./network.nix
          ./nix.nix
          ./security.nix
        ];

        desktopModules = with inputs; [
          hyprland.nixosModules.default
          kmonad.nixosModules.default
          nix-gaming.nixosModules.default
        ];
      };
    }
  ];

  flake.nixosModules = {
    core = import ./core.nix;
    desktop = import ./desktop.nix;
    gamemode = import ./gamemode.nix;
    greetd = import ./greetd.nix;
    minimal = import ./minimal.nix;
    network = import ./network.nix;
    nix = import ./nix.nix;
  };
}
