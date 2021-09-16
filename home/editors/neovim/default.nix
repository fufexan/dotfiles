{ pkgs, inputs, ... }:

let
  vim-horizon = pkgs.vimUtils.buildVimPlugin {
    name = "vim-horizon";
    src = inputs.vim-horizon;
  };
in
{
  imports = [
    ./options.nix
    ./theming.nix
  ];

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      bufferline-nvim
      feline-nvim
      lexima-vim
      lspkind-nvim
      nvim-lspconfig
      nvim-tree-lua
      nvim-treesitter
      nvim-ts-rainbow
      nvim-web-devicons
      telescope-nvim
      vim-nix
      vim-fugitive
      vim-horizon
    ];

    # for treesitter
    extraPackages = [ pkgs.gcc ];

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = false;
    withRuby = false;
  };
}
