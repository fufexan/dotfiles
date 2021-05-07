{ config, pkgs, ... }:

{
  # moved to Home Manager
  environment.variables = { EDITOR = "nvim"; };
  environment.systemPackages = with pkgs; [
    (neovim.override {
      vimAlias = true;
      configure = {
        packages.plugins = with pkgs.vimPlugins; {
          start = [ vim-nix coc-nvim coc-pairs coc-prettier coc-snippets coc-highlight latex-live-preview ];
          opt = [ ];
        };
        customRC = "source ~/.config/nvim/init.vim";
      };
    })

    # needed for coc.nvim
    nodejs
  ];
}
