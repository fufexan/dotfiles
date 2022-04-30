{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [inputs.helix.defaultPackage.${pkgs.system}];

  home.file.".config/helix".source = ./config;
}
