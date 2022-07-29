inputs: let
  inherit (inputs) self;
  inherit (inputs.hm.lib) homeManagerConfiguration;

  theme = "catppuccin";

  colors = with self.lib; rec {
    baseColors = inputs.nix-colors.colorSchemes.${theme}.colors;
    # normal hex values
    xcolors = mapAttrs (_: x) baseColors;
    # rgba hex values
    xrgbaColors = mapAttrs (_: xrgba) baseColors;
    # argb hex values
    xargbColors = mapAttrs (_: xargb) baseColors;
    # 0xABCDEF colors (alacritty)
    x0Colors = mapAttrs (_: x0) baseColors;
    # rgba(,,,) colors (css)
    rgbaColors = mapAttrs (_: rgba) baseColors;
  };

  extraSpecialArgs = {inherit colors inputs;};

  defArgs = rec {
    configuration = {};
    system = "x86_64-linux";
    inherit extraSpecialArgs;
  };

  mkHome = args:
    homeManagerConfiguration (defArgs
      // args
      // {
        homeDirectory = "/home/${args.username}";
        pkgs = inputs.self.pkgs.${args.system or defArgs.system};
      });
in {inherit mkHome extraSpecialArgs;}
