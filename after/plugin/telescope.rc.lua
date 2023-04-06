local status, telescope = pcall(require, 'telescope')

if (not status) then return end

local actions = require('telescope.actions')

local function telescope_buffer_dir()
	return vim.fn.expand('%:p:h')
end

local fb_actions = require('telescope').extensions.file_browser.actions

telescope.setup {
	defaults = {
		mappings = {
			n = {
				['q'] = actions.close
			}
		}
	},
	extensions = {
		file_browser = {
			theme = 'dropdown',
			hijack_netrw = true,
		}
	}
}

telescope.load_extension('file_browser')
