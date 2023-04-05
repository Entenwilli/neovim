local status, lualine = pcall(require, 'lualine')

if (not status) then return end

lualine.setup {
	options = {
		icons_enabled = true,
		theme = 'solarized_dark',
		section_separators = { left = '', right = ''},
		component_separators = { left = '', right = ''},
		disabled_filetypes = { }
	},
	sections = {
		lualine_a = { 'mode '},
		lualine_b = { 'branch' },
		lualine_c = {{
			'filename',
			-- Display filestatus
			file_status = true,
			-- Just display filename
			path = 0
		}},
		lualine_x = {
			{
				'diagnostics', 
				sources = { 'nvim_diagnostic' },
				symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
			},
			'encoding',
			'filetype'
		},
		lualine_y = { 'progress' },
		lualine_z = { 'location' }
	},
	inactive_sections = {}
}
