{
  pkgs,
  config,
  self,
  ...
}: {
  home.packages = with pkgs; [gtklock];

  xdg.configFile."gtklock/style.css".source = "${self}/home/wayland/gtklock/style-${config.programs.matugen.variant}.css";
}
