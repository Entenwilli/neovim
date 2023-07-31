local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local status, lazy = pcall(require, "lazy")
if not status then
	return
end

lazy.setup({
	"folke/lazy.nvim",
	"nvim-lua/plenary.nvim",
	-- Colorscheme
	"folke/tokyonight.nvim",

	-- Autocompletions
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
		},
	},

	-- Snippets
	"L3MON4D3/LuaSnip",

	-- LSP
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
	},
	"onsails/lspkind.nvim",

	-- Telescope
	"nvim-telescope/telescope.nvim",

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},
	"RRethy/vim-illuminate",

	-- Autopairs
	{
		"windwp/nvim-autopairs",
		lazy = true,
	},

	-- Gitsigns
	"lewis6991/gitsigns.nvim",

	-- Neovim tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"mrbjarksen/neo-tree-diagnostics.nvim",
		},
	},

	-- Lualine
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
	},

	-- Alpha dashboard
	"goolord/alpha-nvim",

	-- Identation guides
	"lukas-reineke/indent-blankline.nvim",

	-- Project management
	"ahmedkhalf/project.nvim",

	-- Keybind helper
	"folke/which-key.nvim",

	-- Add terminal
	"akinsho/toggleterm.nvim",

	-- Discord integration
	"andweeb/presence.nvim",

	-- UI
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},
	"stevearc/dressing.nvim",
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
	},
	"ray-x/lsp_signature.nvim",
	"MunifTanjim/prettier.nvim",
})
