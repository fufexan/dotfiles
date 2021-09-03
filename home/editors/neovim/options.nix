let
  c = (import ../../colors.nix).normal;
in
{
  programs.neovim.extraConfig = ''
    local o = vim.opt
    local g = vim.g

    local t = function(str)
      return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    o.number = true
    o.relativenumber = true

    o.showmode = false
    o.hidden = true

    g.nvim_tree_hide_dotfiles = 1
    g.rust_recommended_style = 0
    g.mapleader = ' '
    g.lexima_no_default_rules = 1

    vim.cmd 'filetype plugin indent on'
    o.tabstop = 2
    o.softtabstop = 2
    o.shiftwidth = 2
    o.expandtab = true
    o.completeopt = 'menuone,noselect'
    o.shortmess = o.shortmess + 'c'

    -- keymaps
    vim.api.nvim_set_keymap( 'n', ';', ':', {noremap = true})
    vim.api.nvim_set_keymap( 'n', ':', ';', {noremap = true})
    vim.api.nvim_set_keymap( 'v', '<F12>', '"+y', {noremap = true})
    vim.api.nvim_set_keymap( 'n', '<F12>', 'ggVG"+y', {noremap = true})

    -- autocmd
    vim.cmd 'autocmd BufWritePre *.nix lua vim.lsp.buf.formatting_sync(nil, 1000)'

    -- lsp
    local lspc = require 'lspconfig'
    lspc.rnix.setup {}

    -- lsp icons
    require('lspkind').init {
      with_text = false
    }

    -- bufferline
    require('bufferline').setup {
      options = {
        show_close_icon = false,
        show_buffer_close_icons = false,
        offsets = {{
          filetype = 'NvimTree',
          text = 'File Explorer',
          text_align = 'center'
        }}
      }
    }
    -- tree sitter
    require('nvim-treesitter.configs').setup {
      --ensure_installed = {"bash", "c", "css", "javascript", "json", "lua", "nix", "rust", "toml"},
      highlight = {
        enable = true,
        disable = {"css"}
      },
      rainbow = {
        enable = true,
        disable = {"html"},
        extended_mode = true,
        max_file_lines = 10000,
        colors = {"#${c.red}", "#${c.green}", "#${c.yellow}", "#${c.blue}", "#${c.cyan}", "#${c.magenta}", "#${c.white}"}
      }
    }

    -- telescope
    require('telescope').load_extension('fzy_native')

    -- lexima
    vim.fn['lexima#set_default_rules']()
    
  '';
}
