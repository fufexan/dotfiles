{
  pkgs,
  inputs,
  ...
}:
# nix tooling
{
  home.packages = with pkgs; [
    alejandra
    deadnix
    nix-index
    statix
    inputs.self.packages.${pkgs.system}.repl
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };
}
