local status, which_key = pcall(require, "which-key")
if not status then
	return
end

local setup = {
	marks = true,
	registers = true,
	spelling = {
		enabled = true,
		suggestions = 20,
	},
	presets = {
		operators = true,
		motions = true,
		text_objects = true,
		windows = true,
		nav = true,
		z = true,
		g = true,
	},
	operators = { gc = "Comments" },
	motions = {
		count = true,
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	popup_mappings = {
		scroll_down = "<c-d>", -- binding to scroll down inside the popup
		scroll_up = "<c-u>", -- binding to scroll up inside the popup
	},
	window = {
		border = "none", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "left", -- align columns left, center or right
	},
	ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " }, -- hide mapping boilerplate
	show_help = true, -- show a help message in the command line for using WhichKey
	show_keys = true, -- show the currently pressed key and its label as a message in the command line
	triggers = "auto", -- automatically setup triggers
	triggers_nowait = {
		"`",
		"'",
		"g`",
		"g'",
		'"',
		"<c-r>",
		"z=",
	},
	triggers_blacklist = {
		i = { "j", "k" },
		v = { "j", "k" },
	},
	disable = {
		buftypes = {},
		filetypes = {},
	},
}

local mappings = {
	['a'] = { "<cmd>Alpha<cr>", "Alpha" },
  ['e'] = { '<cmd>NvimTreeToggle<cr>', 'Explorer' },
	['f'] = { "<cmd>Telescope find_files<cr>", "Find files" },
	['F'] = { "<cmd>Telescope live_grep<cr>", "Find text" },
	['P'] = { "<cmd>Telescope projects<cr>", "Projects" },
	g = {
		name = "git",
		g = { "<cmd>lua _LAZYGIT_TOGGLE()<cr>", "Lazygit" },
	},
	l = {
		name = "LSP",
		a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
		d = {
			"<cmd>Telescope lsp_document_diagnostics<cr>",
			"Document Diagnostics",
		},
		w = {
			"<cmd>Telescope lsp_workspace_diagnostics<cr>",
			"Workspace Diagnostics",
		},
		f = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format" },
		i = { "<cmd>LspInfo<cr>", "Info" },
		j = {
			"<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
			"Next Diagnostic",
		},
		k = {
			"<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
			"Prev Diagnostic",
		},
		l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
		q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Quickfix" },
		r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
		s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
		S = {
			"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
			"Workspace Symbols",
		},
	},
  t = {
    name = 'Terminal',
    f = { '<cmd>ToggleTerm direction=float<cr>', 'Float' },
    h = { '<cmd>ToggleTerm size=10 direction=horizontal<cr>', 'Horizontal' },
  }
}

which_key.setup(setup)
which_key.register(mappings, { prefix = "<leader>" })
