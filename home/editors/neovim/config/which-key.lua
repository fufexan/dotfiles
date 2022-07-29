vim.g.mapleader = " "

local wk = require("which-key")

wk.setup({})

wk.register({
  ["<leader>"] = {
    b = { "<cmd>Telescope buffers<cr>", "Buffers" },
    ["/"] = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    g = {
      name = "Git / VCS",
      i = { "<cmd>lua require('telescope').extensions.gh.issues()<cr>", "Github Issues" },
      p = { "<cmd>lua require('telescope').extensions.gh.pull_request()<cr>", "Github PRs" },
      b = { "<cmd>ToggleBlameLine<cr>", "Toggle BlameLine" },
      c = { "<cmd>Neogit commit<cr>", "Commit" },
      s = { "<cmd>Neogit kind=split<cr>", "Staging" },
    },
    a = { "<cmd>lua require('telescope.builtin').lsp_code_actions()<cr>", "Code Actions" },
    d = { "<cmd>lua require('telescope.builtin').lsp_document_diagnostics()<cr>", "LSP Diagnostics" },
    k = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature Help" },
    l = {
      name = "LSP",
      f = { "<cmd>lua vim.lsp.buf.formatting_sync()<cr>", "Format file"},
      q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Set Loclist" },
      e = { "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>", "Show Line Diagnostics" },
    },
      p = { "\"+p", "Paste from clipboard" },
      P = { "\"+P", "Paste from clipboard before cursor" },
      y = { "\"+y", "Yank to clipboard" },
    },
  g = {
    l = { "$", "Line end" },
    h = { "0", "Line start" },
    s = { "^", "First non-blank in line" },
    e = { "G", "Bottom" },
  },
})
