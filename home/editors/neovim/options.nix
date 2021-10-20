{ colors, ... }:
let
  c = colors.normal;
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
    o.completeopt = 'menu,menuone,noselect'
    o.shortmess = o.shortmess + 'c'

    -- keymaps
    vim.api.nvim_set_keymap( 'n', '<ESC>', '<ESC>:nohlsearch<CR>', {noremap = true})
    vim.api.nvim_set_keymap( 'v', '<F12>', '"+y', {noremap = true})
    vim.api.nvim_set_keymap( 'n', '<F12>', ':%+y<CR>', {noremap = true})

    -- autocmd
    vim.cmd 'autocmd BufWritePre *.nix lua vim.lsp.buf.formatting_sync(nil, 1000)'

    -- autopairs
    require('nvim-autopairs').setup({
      fast_wrap = {}
    })
    require('nvim-autopairs').setup({
      enable_check_bracket_line = false,

      fast_wrap = {
        map = '<M-e>',
        chars = { '{', '[', '(', '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ${"''"}),
        offset = 0, -- Offset from pattern match
        end_key = '$',
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        check_comma = true,
        highlight = 'Search',
        highlight_grey='Comment'
      },
    })

    -- cmp  
    local cmp = require'cmp'

    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = {
        -- ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        -- ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
      }
    })

    -- autopairs
    require("nvim-autopairs.completion.cmp").setup({
      map_cr = true, --  map <CR> on insert mode
      map_complete = true, -- it will auto insert `(` (map_char) after select function or method item
      auto_select = true, -- automatically select the first item
      insert = false, -- use insert confirm behavior instead of replace
      map_char = { -- modifies the function or method delimiter by filetypes
        all = '(',
        tex = '{'
      }
    })

    -- lspconfig
    require('lspconfig')['rnix'].setup {
      -- capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    }

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
      ensure_installed = {"bash", "haskell", "json", "lua", "nix", "toml"},
      highlight = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
      indent = {
        enable = true,
      },
      rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = 10000,
        colors = {"#${c.red}", "#${c.green}", "#${c.yellow}", "#${c.blue}", "#${c.cyan}", "#${c.magenta}", "#${c.white}"}
      }
    }
    o.foldmethod = 'expr' 
    o.foldexpr = 'nvim_treesitter#foldexpr()'

    -- telescope
    --require('telescope').setup{}
    
  '';
}
