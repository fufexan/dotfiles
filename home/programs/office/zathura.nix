{ pkgs, ... }:
{
  programs.zathura = {
    enable = true;
    options = {
      recolor-lightcolor = "rgba(0,0,0,0)";
      default-bg = "rgba(0,0,0,0.7)";

      font = "Inter 12";
      selection-notification = true;

      selection-clipboard = "clipboard";
      adjust-open = "best-fit";
      pages-per-row = "1";
      scroll-page-aware = "true";
      scroll-full-overlap = "0.01";
      scroll-step = "100";
      zoom-min = "10";
    };

    extraConfig = "include catppuccin-mocha";
  };

  xdg.configFile = {
    "zathura/catppuccin-latte".source = pkgs.fetchurl {
      name = "zathura-catppuccin-latte";
      url = "https://raw.githubusercontent.com/catppuccin/zathura/9f29c2c1622c70436f0e0b98fea9735863596c1e/themes/catppuccin-latte";
      hash = "sha256-GbSSl8k0Rqtq5IwcAHE7BiTajozNc+z+VhCAkbFDi2E=";
    };
    "zathura/catppuccin-mocha".source = pkgs.fetchurl {
      name = "zathura-catppuccin-mocha";
      url = "https://raw.githubusercontent.com/catppuccin/zathura/9f29c2c1622c70436f0e0b98fea9735863596c1e/themes/catppuccin-mocha";
      hash = "sha256-aUUT1ExI5kEeEawwqnW+n0XWe2b5j4tFdJbCh4XCFIs=";
    };
  };
}
