{ pkgs, config, inputs, ... }:

# nix tooling

{
  home.packages = with pkgs; [
    nix-index
    nixpkgs-fmt
    inputs.rnix-lsp.defaultPackage.x86_64-linux
    inputs.nix-eval-lsp.defaultPackage.x86_64-linux
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
