-- telescope
require('telescope').load_extension('fzy_native')

-- null-ls
local nb = require('null-ls').builtins

require('null-ls').setup({
    sources = {
        nb.formatting.alejandra,
        nb.code_actions.statix,
        nb.diagnostics.cppcheck,
        nb.diagnostics.deadnix,
        nb.diagnostics.statix,
        nb.diagnostics.eslint,
        nb.completion.spell,
    },
})

require("gitsigns").setup()

-- autopairs
require('nvim-autopairs').setup{}

-- copy to system clipboard
vim.api.nvim_set_keymap( 'v', '<Leader>y', '"+y', {noremap = true})
vim.api.nvim_set_keymap( 'n', '<Leader>y', ':%+y<CR>', {noremap = true})

-- paste from system clipboard
vim.api.nvim_set_keymap( 'n', '<Leader>p', '"+p', {noremap = true})
