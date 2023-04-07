local status, packer = pcall(require, 'packer')
if (not status) then
	print("Packer is not installed")
end

vim.cmd [[packadd packer.nvim]]

packer.startup(function(use)
	use 'wbthomason/packer.nvim'
	-- Status line
	use 'nvim-lualine/lualine.nvim'
	-- Color scheme
	use 'folke/tokyonight.nvim'
	-- LSP setup
	use 'neovim/nvim-lspconfig'
	-- LSP installer
	use {
		'williamboman/mason.nvim',
		run = ":MasonUpdate"
	}
	use 'williamboman/mason-lspconfig.nvim'
	-- Autocompletion
	use 'onsails/lspkind-nvim'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/nvim-cmp'
	-- Snippets
	use 'L3MON4D3/LuaSnip'
	-- Highlighting
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ":TSUpdate"
	}
	-- Autopairs
	use 'windwp/nvim-autopairs'
	-- Search
	use 'nvim-lua/plenary.nvim'
	use 'nvim-telescope/telescope.nvim'
	use 'nvim-telescope/telescope-file-browser.nvim'
	-- Keybindings
	use 'folke/which-key.nvim'
	-- File explorer
	use 'nvim-tree/nvim-tree.lua'
	use 'nvim-tree/nvim-web-devicons'
end)
