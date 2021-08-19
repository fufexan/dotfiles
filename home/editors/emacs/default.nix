{ pkgs, inputs, ... }:

{
  programs.emacs = {
    enable = true;
    package = inputs.nobbz.packages.x86_64-linux.emacsPgtkGcc;

    extraPackages = epkgs: with epkgs; [
      editorconfig
      eglot
      horizon-theme
      nix-mode
      phi-autopair
    ];
  };
}
