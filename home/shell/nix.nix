{pkgs, ...}:
# nix tooling
{
  home.packages = with pkgs; [
    alejandra
    deadnix
    nix-index
    repl
    rnix-lsp
    statix
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };
}
