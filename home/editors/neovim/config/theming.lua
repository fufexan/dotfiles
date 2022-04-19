-- set colorscheme
vim.cmd 'set termguicolors'
vim.cmd 'colorscheme horizon'

-- enable colorizer
require'colorizer'.setup()

-- set sign
vim.cmd 'sign define DiagnosticSignError text=  linehl= texthl=DiagnosticSignError numhl='
vim.cmd 'sign define DiagnosticSignHint text=  linehl= texthl=DiagnosticSignHint numhl='
vim.cmd 'sign define DiagnosticSignInfo text=  linehl= texthl=DiagnosticSignInfo numhl='
vim.cmd 'sign define DiagnosticSignWarn text=  linehl= texthl=DiagnosticSignWarn numhl='

-- set lightline theme to horizon
vim.g.lightline = { colorscheme = 'horizon' }
