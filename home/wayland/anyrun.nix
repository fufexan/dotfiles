{inputs', ...}: {
  programs.anyrun = {
    enable = true;

    config = {
      plugins = with inputs'.anyrun.packages; [
        applications
        randr
        rink
        shell
        symbols
        translate
      ];

      width.fraction = 0.3;
      y.absolute = 15;
      hidePluginInfo = true;
      closeOnClick = true;
    };

    extraCss = ''
      * {
        transition: 200ms ease;
        font-family: Lexend;
        font-size: 1.3rem;
      }

      #window,
      #match,
      #entry,
      #plugin,
      #main {
        background: transparent;
      }

      #match:selected {
        background: rgba(203, 166, 247, 0.7);
      }

      #match {
        padding: 3px;
        border-radius: 16px;
      }

      #entry, #plugin:hover {
        border-radius: 16px;
      }

      box#main {
        background: rgba(30, 30, 46, 0.7);
        border: 1px solid #28283d;
        border-radius: 24px;
        padding: 8px;
      }
    '';
  };
}
