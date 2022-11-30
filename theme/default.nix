inputs: {
  default = with inputs.self.lib; rec {
    colors = import ./colors.nix;
    # #RRGGBB
    xcolors = mapAttrs (_: x) colors;
    # #RRGGBBAA
    xrgbaColors = mapAttrs (_: xrgba) colors;
    # rgba(,,,) colors (css)
    rgbaColors = mapAttrs (_: rgba) colors;

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
}
