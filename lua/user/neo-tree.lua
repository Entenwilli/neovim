local status, tree = pcall(require, "neo-tree")
if not status then
	return
end

local icons = require("user.common.icons")

tree.setup({
	enable_git_status = true,
	enable_diagnostics = true,
	sources = {
		"filesystem",
		"buffers",
		"git_status",
		"diagnostics",
	},
	source_selector = {
		winbar = true,
		statusline = false, -- toggle to show selector on statusline
		content_layout = "center",
		tabs_layout = "equal",
		sources = {
			{ source = "filesystem", display_name = "  " },
			{ source = "buffers", display_name = "  " },
			{ source = "git_status", display_name = "  " },
			{ source = "diagnostics", display_name = " 裂" },
		},
	},
	default_component_configs = {
		indent = {
			indent_size = 2,
			padding = 1, -- extra padding on left hand side
			-- indent guides
			with_markers = true,
			indent_marker = "│",
			last_indent_marker = "└", -- └
			-- indent_marker = "▏",
			-- last_indent_marker = "▏",
			highlight = "NeoTreeIndentMarker",
			-- expander config, needed for nesting files
			with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
			-- expander_collapsed = "",
			-- expander_expanded = "",

			-- expander_collapsed = " ",
			-- expander_expanded = " ",
			expander_collapsed = "",
			expander_expanded = "",
			expander_highlight = "NeoTreeExpander",
		},
		modified = {
			symbol = "[+]",
			highlight = "NeoTreeModified",
		},
		name = {
			trailing_slash = false,
			use_git_status_colors = true,
			highlight = "NeoTreeFileName",
		},
		git_status = {
			symbols = {
				-- Change type
				added = icons.git.added, -- or "✚", but this is redundant info if you use git_status_colors on the name
				modified = icons.git.modified, -- or "", but this is redundant info if you use git_status_colors on the name
				deleted = icons.git.removed, -- this can only be used in the git_status source
				renamed = "", -- this can only be used in the git_status source
				-- Status type
				untracked = "",
				ignored = "",
				-- unstaged = "",
				unstaged = "U",
				staged = "",
				conflict = "",
			},
		},
		diagnostics = {
			symbols = {
				hint = icons.diagnostics.Hint,
				info = icons.diagnostics.Info,
				warn = icons.diagnostics.Warn,
				error = icons.diagnostics.Error,
			},
			highlights = {
				hint = "DiagnosticSignHint",
				info = "DiagnosticSignInfo",
				warn = "DiagnosticSignWarn",
				error = "DiagnosticSignError",
			},
		},
	},
})
