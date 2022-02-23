inputs:

let
  inherit (inputs) self;
  inherit (inputs.hm.lib) homeManagerConfiguration;

  theme = "horizon-terminal-dark";

  colors = with self.lib; rec {
    baseColors = inputs.nix-colors.colorSchemes.${theme}.colors;
    # normal hex values
    xcolors = mapAttrs (n: v: x v) baseColors;
    # argb hex values
    xrgbaColors = mapAttrs (n: v: xrgba v) baseColors;
    # 0xABCDEF colors (alacritty)
    x0Colors = mapAttrs (n: v: x0 v) baseColors;
    # rgba(,,,) colors (css)
    rgbaColors = mapAttrs (n: v: rgba v) baseColors;
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
