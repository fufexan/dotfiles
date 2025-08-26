{
  pkgs,
  self,
  ...
}:
# nix tooling
{
  home.packages = with pkgs; [
    alejandra # keep around until migating all projects to nixfmt
    deadnix
    nixfmt
    statix
    self.packages.${pkgs.system}.repl
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };
}
