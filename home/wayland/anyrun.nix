{
  pkgs,
  inputs,
  osConfig,
  ...
}: {
  programs.anyrun = {
    enable = true;

    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        randr
        rink
        shell
        symbols
        translate
        inputs.anyrun-nixos-options.packages.${pkgs.system}.default
      ];

      width.fraction = 0.3;
      y.absolute = 15;
      hidePluginInfo = true;
      closeOnClick = true;
    };

    extraCss = ''
      * {
        font-family: Product Sans;
        font-size: 1.3rem;
      }

      #window,
      #match,
      #entry,
      #plugin,
      #main {
        background: transparent;
      }

      .vertical > list > row:first-child {
        margin-top: 5px;
      }

      #match {
        margin: 1px;
        padding: 2px;
        border-radius: 14px;
      }

      #match:selected, #match:hover, #plugin:hover {
        background: rgba(255, 255, 255, .1);
      }

      #entry, #plugin:hover {
        border-radius: 16px;
      }

      box#main {
        background: rgba(0, 0, 0, .3);
        box-shadow: inset 0 0 0 1px rgba(255, 255, 255, .1), 0 0 0 1px rgba(0, 0, 0, .4);
        border-radius: 24px;
        padding: 8px;
      }
    '';

    extraConfigFiles."nixos-options.ron".text = ''
      Config(
        options_path: "${osConfig.system.build.manual.optionsJSON}/share/doc/nixos/options.json"
      )
    '';
  };
}
