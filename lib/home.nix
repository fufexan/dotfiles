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

    wallpaper = builtins.fetchurl rec {
      name = "wallpaper-${sha256}.png";
      url = "https://files.catbox.moe/wn3b28.png";
      sha256 = "0f7q0aj1q6mjfh248j8dflfbkbcpfvh5wl75r3bfhr8p6015jkwq";
    };
  };
in {inherit mkHome extraSpecialArgs default;}
