inputs: let
  colors = with inputs.self.lib; let
    theme = "catppuccin";
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
in {inherit extraSpecialArgs default;}
