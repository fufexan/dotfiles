{ pkgs, config, inputs, ... }:

# nix tooling

{
  home.packages = with pkgs; [
    nix-index
    nixpkgs-fmt
    inputs.rnix-lsp.defaultPackage.x86_64-linux
    repl
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };
}
