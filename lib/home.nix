inputs: let
  inherit (inputs) self;

  theme = "catppuccin";

  colors = with self.lib; let
    baseColors = inputs.nix-colors.colorSchemes.${theme}.colors;
  in {
    inherit baseColors;
    # #RRGGBB
    xcolors = mapAttrs (_: x) baseColors;
    # #RRGGBBAA
    xrgbaColors = mapAttrs (_: xrgba) baseColors;
    # #AARRGGBB
    xargbColors = mapAttrs (_: xargb) baseColors;
    # rgba(,,,) colors (css)
    rgbaColors = mapAttrs (_: rgba) baseColors;
  };

  extraSpecialArgs = {inherit colors inputs default;};

  defArgs = {
    inherit extraSpecialArgs;
    pkgs = inputs.self.pkgs.x86_64-linux;
  };

  mkHome = args:
    inputs.hm.lib.homeManagerConfiguration (defArgs // args);

  default = {
    browser = "firefox";
    terminal = {
      font = "JetBrainsMono Nerd Font";
      name = "wezterm";
      opacity = 0.9;
      size = 11;
    };
  };
in {inherit mkHome extraSpecialArgs;}
