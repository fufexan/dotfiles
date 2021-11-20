{ pkgs, inputs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs; #inputs.nobbz.packages.x86_64-linux.emacsPgtkGcc;

    extraPackages = epkgs: with epkgs; [
      # themes
      horizon-theme

      doom

      # language modes
      #markdown-mode
      #nix-mode

      #evil

      ## QoL
      #consult
      #editorconfig
      #lsp-mode
      #magit
      #multiple-cursors
      #nixpkgs-fmt
      #phi-autopair
      #treemacs
      #undo-tree
      #vertico
    ];
  };
}
