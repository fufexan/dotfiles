{ pkgs, config, inputs, ... }:

# nix tooling

{
  home.packages = with pkgs; [
    fup-repl
    nix-index
    nixpkgs-fmt
    #rnix-lsp
    inputs.rnix-lsp.defaultPackage.x86_64-linux
  ];

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
      enableFlakes = true;
    };
    enableZshIntegration = true;
  };
}
