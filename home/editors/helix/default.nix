{ pkgs, inputs, ... }:

{
  home.packages = [ inputs.helix.defaultPackage.x86_64-linux ];

  home.file.".config/helix".source = ./config;
}
