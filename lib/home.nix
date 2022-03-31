inputs:

let
  inherit (inputs) self;
  inherit (inputs.hm.lib) homeManagerConfiguration;

  theme = "horizon-terminal-dark";

  colors = with self.lib; rec {
    baseColors = inputs.nix-colors.colorSchemes.${theme}.colors;
    # normal hex values
    xcolors = mapAttrs (n: x) baseColors;
    # argb hex values
    xrgbaColors = mapAttrs (n: xrgba) baseColors;
    # 0xABCDEF colors (alacritty)
    x0Colors = mapAttrs (n: x0) baseColors;
    # rgba(,,,) colors (css)
    rgbaColors = mapAttrs (n: rgba) baseColors;
  };

  extraSpecialArgs = { inherit colors inputs; };

  defArgs = rec {
    configuration = { };
    system = "x86_64-linux";
    inherit extraSpecialArgs;
  };

  mkHome = args: homeManagerConfiguration (defArgs // args // {
    homeDirectory = "/home/${args.username}";
    pkgs = inputs.self.pkgs.${args.system or defArgs.system};
  });
in
{ inherit mkHome extraSpecialArgs; }
