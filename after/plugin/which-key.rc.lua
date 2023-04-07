local status, key = pcall(require, 'which-key')

if (not status) then return end

vim.g.mapleader = ' '

key.register({
	f = {
		name = 'Files',
		f = { '<cmd>Telescope find_files<cr>', 'Find File' },
		e = { '<cmd>NvimTreeToggle<cr>', 'Open explorer' }
	},
	p = {
		name = 'Packer',
		s = { '<cmd>PackerSync<cr>', 'Packer Sync' },
		i = { '<cmd>PackerInstall<cr>', 'Packer Install' }
	},
	t = {
		name = 'Telescope',
		t = { '<cmd>Telescope<cr>', 'Open Telescope' }
	},
	l = {
		name = 'LSP',
		f = { '', 'Format' }
	}
}, {
	prefix = '<leader>'
})

key.setup {
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
	operators = { gc = 'Comments' },
	motions = {
		count = true,
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it's label
		group = "+",    -- symbol prepended to a group
	},
	popup_mappings = {
		scroll_down = "<c-d>", -- binding to scroll down inside the popup
		scroll_up = "<c-u>", -- binding to scroll up inside the popup
	},
	window = {
		border = "none",        -- none, single, double, shadow
		position = "bottom",    -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0,           -- value between 0-100 0 for fully opaque and 100 for fully transparent
	},
	layout = {
		height = { min = 4, max = 25 },                                                -- min and max height of the columns
		width = { min = 20, max = 50 },                                                -- min and max width of the columns
		spacing = 3,                                                                   -- spacing between columns
		align = "left",                                                                -- align columns left, center or right
	},
	ignore_missing = false,                                                          -- enable this to hide mappings for which you didn't specify a label
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " }, -- hide mapping boilerplate
	show_help = true,                                                                -- show a help message in the command line for using WhichKey
	show_keys = true,                                                                -- show the currently pressed key and its label as a message in the command line
	triggers = "auto",                                                               -- automatically setup triggers
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
