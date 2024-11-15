{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [inputs.quickshell.packages.${pkgs.system}.default];
}
