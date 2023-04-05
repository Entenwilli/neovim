local status, packer = pcall(require, 'packer')
if (not status) then
	print("Packer is not installed")
end

vim.cmd[[packadd packer.nvim]]

packer.startup(function(use)
	use 'wbthomason/packer.nvim'
	-- Status line
	use 'nvim-lualine/lualine.nvim'
	-- LSP setup
	use 'neovim/nvim-lspconfig'
	-- LSP installer
	use {
		'williamboman/mason.nvim'
	}
end) 
