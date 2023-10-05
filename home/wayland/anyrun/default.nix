{
  pkgs,
  inputs,
  config,
  osConfig,
  self,
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

    extraCss = builtins.readFile "${self}/home/wayland/anyrun/style-${config.programs.matugen.variant}.css";

    extraConfigFiles."nixos-options.ron".text = ''
      Config(
        options_path: "${osConfig.system.build.manual.optionsJSON}/share/doc/nixos/options.json",
        max_entries: 5,
      )
    '';
  };
}
