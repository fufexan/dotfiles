{
  pkgs,
  default,
  ...
}: {
  programs. zathura = let
    inherit (default) xcolors;
  in {
    enable = true;
    options = {
      recolor = true;
      recolor-darkcolor = "#${xcolors.crust}";
      recolor-lightcolor = "rgba(0,0,0,0)";
      default-bg = "rgba(0,0,0,0.7)";
      default-fg = "#${xcolors.text}";

      font = "Roboto 12";

      # TODO: fix colors
      completion-bg = xcolors.bg;
      completion-fg = xcolors.fg;
      completion-highlight-bg = xcolors.base;
      completion-highlight-fg = xcolors.fg;
      completion-group-bg = xcolors.base;
      completion-group-fg = xcolors.blue;

      statusbar-fg = xcolors.lavender;
      statusbar-bg = xcolors.base;
      statusbar-h-padding = 10;
      statusbar-v-padding = 10;

      notification-bg = xcolors.base;
      notification-fg = xcolors.fg;
      notification-error-bg = xcolors.base;
      notification-error-fg = xcolors.red;
      notification-warning-bg = xcolors.base;
      notification-warning-fg = xcolors.peach;
      selection-notification = true;

      inputbar-fg = xcolors.text;
      inputbar-bg = xcolors.base;

      index-fg = xcolors.fg;
      index-bg = xcolors.surface0;
      index-active-fg = xcolors.fg;
      index-active-bg = xcolors.base;

      render-loading-bg = xcolors.surface0;
      render-loading-fg = xcolors.fg;

      highlight-color = xcolors.subtext1;
      highlight-active-color = xcolors.pink;
      highlight-fg = xcolors.pink;

      selection-clipboard = "clipboard";
      adjust-open = "best-fit";
      pages-per-row = "1";
      scroll-page-aware = "true";
      scroll-full-overlap = "0.01";
      scroll-step = "100";
      zoom-min = "10";
    };
  };
}
