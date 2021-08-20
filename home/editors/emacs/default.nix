{ pkgs, inputs, ... }:

{
  programs.emacs = {
    enable = true;
    package = inputs.nobbz.packages.x86_64-linux.emacsPgtkGcc;

    extraPackages = epkgs: with epkgs; [
      # themes
      horizon-theme

      # language modes
      markdown-mode
      nix-mode

      # QoL
      consult
      editorconfig
      eglot
      magit
      multiple-cursors
      nixpkgs-fmt
      phi-autopair
      treemacs
      undo-tree
      vertico
    ];
  };
}
