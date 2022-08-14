{
  pkgs,
  inputs,
  ...
}:
with pkgs; [
  {
    language-server = {command = "${nodePackages.bash-language-server}/bin/bash-language-server";};
    name = "bash";
    auto-format = true;
  }
  {
    language-server = {command = "${inputs.nil.packages.${pkgs.system}.default}/bin/nil";};
    name = "nix";
  }
]
