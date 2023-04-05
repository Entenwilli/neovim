local status, nvim_lsp = pcall(require, 'lspconfig')

if (not atatus) then return end

local protocol = require('vim.lsp.protocol')

local on_attach = function(client, bufnr)
	-- Formatting	
	if client.server_capabilities.documentFormattingProvider then
		vim.api.nvim_command [[autogroup Format]]
		vim.api.nvim_command [[autocmd! * <buffer>]]
		vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
		vim.api.nvim_command [[autogroup END]]
	end
end

nvim_lsp.sumneko_lua.setup {
	on_attach = on_attach,
	settings = {
		Lua = {
			diagnostics = {
				-- Vim / Nvim setup
				globals  = { 'vim' }
			},

			workspace = {
				-- Vim / Nvim runtime files
				library = vim.api.nvim_get_runtime_file("", truesu)
			}
		}
	}
}
