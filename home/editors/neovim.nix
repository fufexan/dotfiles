{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ coc-nvim coc-pairs coc-highlight vim-nix ];
    extraConfig = builtins.readFile ./init.vim;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython = false;
  };
}
