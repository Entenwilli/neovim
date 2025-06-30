return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			term_colors = true,
		},
		priority = 1000,
		init = function()
			vim.cmd([[colorscheme catppuccin-mocha]])
		end,
	},
}
