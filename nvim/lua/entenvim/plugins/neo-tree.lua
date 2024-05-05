local icons = require("entenvim.user.icons")

return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		cmd = "Neotree",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		deactivate = function()
			vim.cmd([[Neotree close]])
		end,
		init = function()
			if vim.fn.argc(-1) == 1 then
				local stat = vim.uv.fs_stat(vim.fn.argv(0))
				if stat and stat.type == "directory" then
					require("neo-tree")
				end
			end
		end,
		keys = {
			{
				"<leader>e",
				function()
					require("neo-tree.command").execute({ toggle = true })
				end,
				desc = "Explorer NeoTree",
			},
		},
		opts = {
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
				statusline = true,
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
		},
	},
	"mrbjarksen/neo-tree-diagnostics.nvim",
}
