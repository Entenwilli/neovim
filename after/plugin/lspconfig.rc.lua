local status, nvim_lsp = pcall(require, 'lspconfig')

if (not status) then return end

local protocol = require('vim.lsp.protocol')

local on_attach = function(client, bufnr)
	-- Formatting	
	if client.server_capabilities.documentFormattingProvider then
		vim.api.nvim_command [[augroup Format]]
		vim.api.nvim_command [[autocmd! * <buffer>]]
		vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
		vim.api.nvim_command [[augroup END]]
	end
end

nvim_lsp.lua_ls.setup {
	on_attach = on_attach,
	settings = {
		Lua = {
			diagnostics = {
				-- Vim / Nvim setup
				globals = { 'vim' }
			},
			workspace = {
				-- Vim / Nvim runtime files
				library = vim.api.nvim_get_runtime_file('', true),
				checkThirdParty = false,
			}
		}
	}
}

nvim_lsp.rust_analyzer.setup {
	on_attach = on_attach
}

nvim_lsp.texlab.setup {
	on_attach = on_attach,
	settings = {
		texlab = {
			build = {
				onSave = true,
				forwardSearchAfter = true
			},
			forwardSearch = {
				executable = 'zathura',
				args = { '--synctex-forward', '%l:1:%f', '%p' },
			}
		}
	}
}

nvim_lsp.astro.setup {
	on_attach = on_attach
}
