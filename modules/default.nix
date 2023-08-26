{
  self,
  inputs,
  default,
  ...
}: let
  # system-agnostic args
  module_args._module.args = {
    inherit default inputs self;
  };
in {
  imports = [
    {
      _module.args = {
        # we need to pass this to HM
        inherit module_args;

        # NixOS modules
        sharedModules = [
          {home-manager.useGlobalPkgs = true;}
          {disabledModules = ["security/pam.nix"];}
          inputs.agenix.nixosModules.default
          inputs.hm.nixosModule
          inputs.hyprland.nixosModules.default
          inputs.kmonad.nixosModules.default
          inputs.nix-gaming.nixosModules.default
          inputs.nh.nixosModules.default
          inputs.lanzaboote.nixosModules.lanzaboote
          module_args
          ./core.nix
          ./howdy
          ./linux-enable-ir-emitter.nix
          ./network.nix
          ./nix.nix
          ./pam.nix
          ./security.nix
        ];
      };
    }
  ];

  flake.nixosModules = {
    core = import ./core.nix;
    bluetooth = import ./bluetooth.nix;
    desktop = import ./desktop.nix;
    gamemode = import ./gamemode.nix;
    greetd = import ./greetd.nix;
    lanzaboote = import ./lanzaboote.nix;
    minimal = import ./minimal.nix;
    network = import ./network.nix;
    nix = import ./nix.nix;
  };
}
