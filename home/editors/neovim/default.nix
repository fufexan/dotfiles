{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      coc-nvim
      coc-pairs
      coc-highlight
      coc-prettier
      coc-snippets
      latex-live-preview
      vim-nix
    ];
    extraConfig = builtins.readFile ./init.vim;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
  };
}
