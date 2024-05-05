-- Set file options
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.writebackup = false

-- Allow neovim to access system clipboard
vim.opt.clipboard = "unnamedplus"

-- Set neovim command height
vim.opt.cmdheight = 2

-- Set endoding
vim.opt.fileencoding = "utf-8"

-- Set tab options
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

-- Enable line numbers
vim.opt.number = true
vim.opt.relativenumber = false
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
	vim.g.neovide_scale_factor = 0.7
end
