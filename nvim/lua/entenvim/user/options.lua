-- Set file options
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.writebackup = false

-- Allow neovim to access system clipboard
vim.opt.clipboard = "unnamedplus"

-- Set neovim command height
vim.opt.cmdheight = 2

-- Set relative line numbers
vim.wo.relativenumber = true

-- Set endoding
vim.opt.fileencoding = "utf-8"

-- Set tab options
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

-- Enable line numbers
vim.opt.number = true
vim.opt.numberwidth = 4

-- Set completion options
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.updatetime = 300

-- Hide mode
vim.opt.showmode = false

-- Set Smart identation and casing
vim.opt.smartcase = true

-- Search options
vim.opt.hlsearch = true
vim.opt.ignorecase = true

-- Disable line wrapping
vim.opt.wrap = false

-- Set shell
vim.opt.shell = "fish"

-- Blending options
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.winblend = 0
vim.opt.wildoptions = "pum"
vim.opt.pumblend = 5
vim.opt.background = "dark"

-- Neovide settings
if vim.g.neovide then
	vim.opt.guifont = "FiraCode Nerd Font:h14" -- the font used in graphical neovim applications
	vim.g.neovide_theme = "auto"
	vim.g.neovide_refresh_rate = 144
	vim.g.terminal_color_0 = "#45475a"
	vim.g.terminal_color_1 = "#f38ba8"
	vim.g.terminal_color_2 = "#a6e3a1"
	vim.g.terminal_color_3 = "#f9e2af"
	vim.g.terminal_color_4 = "#89b4fa"
	vim.g.terminal_color_5 = "#f5c2e7"
	vim.g.terminal_color_6 = "#94e2d5"
	vim.g.terminal_color_7 = "#bac2de"
	vim.g.terminal_color_8 = "#585b70"
	vim.g.terminal_color_9 = "#f38ba8"
	vim.g.terminal_color_10 = "#a6e3a1"
	vim.g.terminal_color_11 = "#f9e2af"
	vim.g.terminal_color_12 = "#89b4fa"
	vim.g.terminal_color_13 = "#f5c2e7"
	vim.g.terminal_color_14 = "#94e2d5"
	vim.g.terminal_color_15 = "#a6adc8"
end
