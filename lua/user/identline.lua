local status, ident_blankline = pcall(require, "ident_blankline")
if not status then
	return
end

vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
vim.g.indent_blankline_filetype_exclude = {
	"help",
	"dashboard",
	"lazy",
	"NvimTree",
}
vim.g.identLine_enabled = 1
vim.g.indent_blankline_char = "▏"
vim.g.indent_blankline_use_treesitter = true

ident_blankline.setup({
	show_current_context = true,
})
