{
  pkgs,
  default,
  inputs,
  config,
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
      ];

      width.fraction = 0.3;
      y.absolute = 15;
      hidePluginInfo = true;
      closeOnClick = true;
    };

    extraCss = builtins.readFile "${self}/home/wayland/anyrun/style-${config.programs.matugen.variant}.css";

    extraConfigFiles."applications.ron".text = ''
      Config(
        desktop_actions: false,
        max_entries: 5,
        terminal: Some("${default.terminal.name}"),
      )
    '';
  };
}
