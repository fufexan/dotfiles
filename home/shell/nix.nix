{ pkgs, ... }:

# nix tooling

{
  home.packages = with pkgs; [
    nix-index
    nixpkgs-fmt
    rnix-lsp
    repl
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };
}
