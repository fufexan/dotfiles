inputs:

let
  inherit (inputs) self;
  inherit (inputs.hm.lib) homeManagerConfiguration;

  extraSpecialArgs = {
    inherit inputs self;
    nix-colors = inputs.nix-colors.colorSchemes.horizon-terminal-dark;
  };

  defArgs = {
    configuration = { };
    system = "x86_64-linux";
    inherit extraSpecialArgs;
  };

  mkHome = args: homeManagerConfiguration (defArgs // args // {
    homeDirectory = "/home/${args.username}";
  });
in
{ inherit mkHome; }
