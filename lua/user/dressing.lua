local status, dressing = pcall(require, "dressing")

if not status then
	return
end

dressing.setup({
	input = {
		border = { "▄", "▄", "▄", "█", "▀", "▀", "▀", "█" }, -- [ top top top - right - bottom bottom bottom - left ]
		win_options = { winblend = 0 },
	},
	select = { telescope = require("user.common.utils").telescope_theme("dropdown") },
})

vim.ui.select = function(...)
	require("lazy").load({ plugins = { "dressing.nvim" } })
	return vim.ui.select(...)
end

vim.ui.input = function(...)
	require("lazy").load({ plugins = { "dressing.nvim" } })
	return vim.ui.input(...)
end
