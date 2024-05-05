{pkgs, ...}: {
  programs.btop = {
    enable = true;
    settings.color_theme = "catppuccin_mocha";
  };

  xdg.configFile = {
    "btop/themes/catppuccin_latte.theme".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/btop/7109eac2884e9ca1dae431c0d7b8bc2a7ce54e54/themes/catppuccin_latte.theme";
      hash = "sha256-Dp/4A4USHAri+QgIM/dJFQyLSR6KlWtMc7aYlFgmHr0=";
    };
    "btop/themes/catppuccin_mocha.theme".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/btop/7109eac2884e9ca1dae431c0d7b8bc2a7ce54e54/themes/catppuccin_mocha.theme";
      hash = "sha256-KnXUnp2sAolP7XOpNhX2g8m26josrqfTycPIBifS90Y=";
    };
  };
}
