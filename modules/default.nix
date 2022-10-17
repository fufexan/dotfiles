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
          {disabledModules = ["security/pam.nix"];}
          inputs.agenix.nixosModules.default
          inputs.hm.nixosModule
          ./minimal.nix
          ./pam.nix
          module_args
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
    desktop = import ./desktop.nix;
    gamemode = import ./gamemode.nix;
    greetd = import ./greetd.nix;
    minimal = import ./minimal.nix;
    nix = import ./nix.nix;
  };
}
