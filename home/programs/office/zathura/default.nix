{
  config,
  lib,
  ...
}:
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

    # includes a mutable "theme" file that darkman points at onedark/onelight
    extraConfig = "include theme";
  };

  xdg.configFile = {
    "zathura/onedark".source = ./onedark;
    "zathura/onelight".source = ./onelight;
  };

  # seed the mutable theme pointer so `include theme` resolves on first launch;
  # darkman re-points it on switch (zathura only reads its config at launch)
  home.activation.zathuraTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    tgt="${config.xdg.configHome}/zathura/theme"
    [ -e "$tgt" ] || run ln -sf onedark "$tgt"
  '';

  services.darkman.scripts.zathura = ''
    if [ "$1" = "light" ]; then variant=onelight; else variant=onedark; fi
    ln -sf "$variant" "${config.xdg.configHome}/zathura/theme"
  '';
}
