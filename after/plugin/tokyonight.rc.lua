local status, theme = pcall(require, 'tokyonight')

if (not status) then return end

theme.setup({
	style = 'night',
	terminal_colors = true
})

vim.cmd [[colorscheme tokyonight-moon]]
