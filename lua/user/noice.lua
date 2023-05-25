local status, noice = pcall(require, "noice")

if not status then
	return
end

noice.setup({
	override = {
		["vim.lsp.util.convert_input_to_markdown_lines"] = true,
		["vim.lsp.util.stylize_markdown"] = true,
		["cmp.entry.get_documentation"] = true,
	},
	cmdline = {
		view = "cmdline",
		format = {
			cmdline = { icon = "  " },
			search_down = { icon = "  󰄼" },
			search_up = { icon = "  " },
			lua = { icon = " " },
		},
	},
	messages = {
		enabled = true,
		view = "notify",
	},
	popupmenu = {
		enabled = true,
		backend = "nui",
	},
	lsp = {
		progress = { enabled = true },
		hover = { enabled = false },
		signature = { enabled = false },
	},
	routes = {
		{
			filter = {
				event = "msg_show",
				kind = "",
				find = "written",
			},
			opts = { skip = true },
		},
	},
})

require("telescope").load_extension("noice")
