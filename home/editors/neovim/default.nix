{ pkgs
, ...
}:

let
  vim-horizon = pkgs.vimUtils.buildVimPlugin rec {
    pname = "vim-horizon";
    version = "unstable-2022-03-17";
    src = pkgs.fetchFromGitHub {
      owner = "ntk148v";
      repo = pname;
      rev = "44826ccfa9319e0dd114ee97784b1e1e53efee40";
      sha256 = "sha256-YVOPb8ehWMdvQi/3WkCsRijP8VE627E1TD4LrLw7hfg=";
    };
  };
  null-ls = pkgs.vimPlugins.null-ls-nvim.overrideAttrs (_: {
    src = pkgs.fetchFromGitHub {
      owner = "jose-elias-alvarez";
      repo = "null-ls.nvim";
      rev = "708aa256d769ddfca474d48330890e7b71e423fd";
      sha256 = "sha256-gTIYyO7S9FIWMzP6PUzmF7G6HKJah2W6q6B2Px60kAE=";
    };
  });
in
{
  programs.neovim = {
    enable = true;

    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
      cmp-spell
      cmp-treesitter
      cmp-vsnip
      friendly-snippets
      gitsigns-nvim
      lightline-vim
      lspkind-nvim
      neogit
      null-ls
      nvim-autopairs
      nvim-cmp
      nvim-colorizer-lua
      nvim-lspconfig
      nvim-tree-lua
      nvim-ts-rainbow
      (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
      plenary-nvim
      telescope-fzy-native-nvim
      telescope-nvim
      vim-floaterm
      vim-horizon
      vim-sneak
      vim-vsnip
      which-key-nvim
    ];

    extraPackages = with pkgs; [ gcc ripgrep fd ];

    extraConfig =
      let
        luaRequire = module: builtins.readFile (builtins.toString
          ./config + "/${module}.lua");
        luaConfig = builtins.concatStringsSep "\n" (map luaRequire [
          "init"
          "lspconfig"
          "nvim-cmp"
          "theming"
          "treesitter"
          "treesitter-textobjects"
          "utils"
          "which-key"
        ]);
      in
      ''
        lua << 
        ${luaConfig}
        
      '';
  };
}
