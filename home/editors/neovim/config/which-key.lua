vim.g.mapleader = " "

local wk = require("which-key")

wk.setup({})

wk.register({
	["<leader>"] = {
		b = {
			name = "Buffer",
			r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
		},
		-- d = {
		-- 	name = "DAP",
		-- 	B = {
		-- 		"<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition:'))<cr>",
		-- 		"Set Breakpoint Conditional",
		-- 	},
		-- 	b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
		-- 	l = { "<cmd>lua require'dap'.repl.run_last()<cr>", "Repl Run Last" },
		-- 	r = { "<cmd>lua require'dap'.repl.open()<cr>", "Open Repl" },
		-- 	p = {
		-- 		"<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message:'))<cr>",
		-- 		"Set Breakpoint Log",
		-- 	},
		-- },
		f = {
			name = "File / Floaterm",
			f = { "<cmd>Telescope find_files<cr>", "Find File" },
			g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
			t = { "<cmd>FloatermToggle<cr>", "Toggle Floaterm" },
			n = { "<cmd>FloatermNew<cr>", "New Floaterm" },
			j = { "<cmd>FloatermNext<cr>", "Next Floaterm" },
			k = { "<cmd>FloatermPrev<cr>", "Prev Floaterm" },
			n = { "<cmd>enew<cr>", "New File" },
		},
		h = {
			name = "Git / VCS",
			i = { "<cmd>lua require('telescope').extensions.gh.issues()<cr>", "Github Issues" },
			p = { "<cmd>lua require('telescope').extensions.gh.pull_request()<cr>", "Github PRs" },
			b = { "<cmd>ToggleBlameLine<cr>", "Toggle BlameLine" },
			-- u = { "<cmd>MundoToggle<cr>", "Toggle Mundo" },
			c = { "<cmd>Neogit commit<cr>", "Commit" },
			s = { "<cmd>Neogit kind=split<cr>", "Staging" },
		},
		l = {
			name = "LSP",
			a = { "<cmd>lua require('telescope.builtin').lsp_code_actions()<cr>", "Code Actions" },
			d = { "<cmd>lua require('telescope.builtin').lsp_document_diagnostics()<cr>", "LSP Diagnostics" },
			f = { "<cmd>lua vim.lsp.buf.formatting_sync()<cr>", "Format file"},
			k = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature Help" },
			q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Set Loclist" },
			e = { "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>", "Show Line Diagnostics" },
		},
		-- m = {
		-- 	name = "Harpoon / Marks",
		-- 	a = { '<cmd>lua require("harpoon.mark").add_file()<cr>', "Mark File (Harpoon)" },
		-- 	u = { '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', "Harpoon UI" },
		-- 	n = { '<cmd>lua require("harpoon.ui").nav_next()<cr>', "Next (Harpoon)" },
		-- 	p = { '<cmd>lua require("harpoon.ui").nav_prev()<cr>', "Prev (Harpoon)" },
		-- 	l = { "<cmd>Telescope harpoon marks<cr>", "Harpoon UI (Telescope)" },
		-- },
		q = {
			name = "QuickFix",
			i = { "<cmd>copen<cr>", "Open" },
			n = { "<cmd>cnext<cr>", "Next" },
			p = { "<cmd>cprevious<cr>", "Previous" },
		},
		s = {
			name = "Session",
			s = { "<cmd>SessionSave<cr>", "Save Session" },
			l = { "<cmd>SessionLoad<cr>", "Load Session" },
		},
		t = {
			name = "Telescope / Terminal",
			e = { "<cmd>lua require('telescope').extensions.emoji.search()<cr>", "Emoji" },
			f = { "<cmd>lua require('telescope').extensions.file_browser.file_browser()<cr>", "File Browser" },
			fr = { "<cmd>lua require('telescope').extensions.frecency.frecency()<cr>", "Frecency" },
			r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
			t = { "<cmd>Telescope<cr>", "Open Telescope" },
		},
		w = {
			name = "Workspace",
			a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", "Add Folder" },
			l = { "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", "List Workspace Folders" },
			r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", "Remove Workspace Folder" },
		},
	},
})
