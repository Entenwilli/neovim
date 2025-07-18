return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		version = false, -- telescope did only one release, so use HEAD for now
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = vim.fn.executable("make") == 1 and "make"
					or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
				enabled = vim.fn.executable("make") == 1 or vim.fn.executable("cmake") == 1,
				config = function()
					EntenVim.on_load("telescope.nvim", function()
						require("telescope").load_extension("fzf")
					end)
				end,
			},
		},
		keys = {
			{
				"<leader>,",
				"<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
				desc = "Switch Buffer",
			},
			{ "<leader>/", EntenVim.telescope.telescope("live_grep"), desc = "Grep (Root Dir)" },
			{ "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
			{
				"<leader><space>",
				EntenVim.telescope.telescope("files"),
				desc = "Find Files (Root Dir)",
			},
			-- find
			{ "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
			{ "<leader>fc", EntenVim.telescope.config_files(), desc = "Find Config File" },
			{
				"<leader>ff",
				EntenVim.telescope.telescope("files"),
				desc = "Find Files (Root Dir)",
			},
			{
				"<leader>fF",
				EntenVim.telescope.telescope("files", { cwd = false }),
				desc = "Find Files (cwd)",
			},
			{ "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find Files (git-files)" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
			{
				"<leader>fR",
				EntenVim.telescope.telescope("oldfiles", { cwd = vim.uv.cwd() }),
				desc = "Recent (cwd)",
			},
			-- git
			{ "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
			{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Status" },
			-- search
			{ '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
			{ "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
			{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
			{ "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
			{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
			{ "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
			{ "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
			{ "<leader>sg", EntenVim.telescope.telescope("live_grep"), desc = "Grep (Root Dir)" },
			{
				"<leader>sG",
				EntenVim.telescope.telescope("live_grep", { cwd = false }),
				desc = "Grep (cwd)",
			},
			{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
			{ "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
			{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
			{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
			{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
			{ "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
			{ "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
			{
				"<leader>sw",
				EntenVim.telescope.telescope("grep_string", { word_match = "-w" }),
				desc = "Word (Root Dir)",
			},
			{
				"<leader>sW",
				EntenVim.telescope.telescope("grep_string", { cwd = false, word_match = "-w" }),
				desc = "Word (cwd)",
			},
			{
				"<leader>sw",
				EntenVim.telescope.telescope("grep_string"),
				mode = "v",
				desc = "Selection (Root Dir)",
			},
			{
				"<leader>sW",
				EntenVim.telescope.telescope("grep_string", { cwd = false }),
				mode = "v",
				desc = "Selection (cwd)",
			},
			{
				"<leader>uC",
				EntenVim.telescope.telescope("colorscheme", { enable_preview = true }),
				desc = "Colorscheme with Preview",
			},
			{
				"<leader>ss",
				function()
					require("entenvim.telescope.builtin").lsp_document_symbols({
						symbols = require("entenvim.config").get_kind_filter(),
					})
				end,
				desc = "Goto Symbol",
			},
			{
				"<leader>fp",
				"<cmd>NeovimProjectDiscover history<cr>",
				desc = "Projects",
			},
			{
				"<leader>sS",
				function()
					require("entenvim.telescope.builtin").lsp_dynamic_workspace_symbols({
						symbols = require("entenvim.config").get_kind_filter(),
					})
				end,
				desc = "Goto Symbol (Workspace)",
			},
		},
		opts = function()
			local actions = require("telescope.actions")

			local open_with_trouble = function(...)
				return require("trouble.providers.telescope").open_with_trouble(...)
			end
			local open_selected_with_trouble = function(...)
				return require("trouble.providers.telescope").open_selected_with_trouble(...)
			end
			local find_files_no_ignore = function()
				local action_state = require("telescope.actions.state")
				local line = action_state.get_current_line()
				EntenVim.telescope.telescope("find_files", { no_ignore = true, default_text = line })()
			end
			local find_files_with_hidden = function()
				local action_state = require("telescope.actions.state")
				local line = action_state.get_current_line()
				EntenVim.telescope.telescope("find_files", { hidden = true, default_text = line })()
			end

			return {
				defaults = {
					prompt_prefix = " ",
					selection_caret = " ",
					-- open files in the first window that is an actual file.
					-- use the current window if no other window is available.
					get_selection_window = function()
						local wins = vim.api.nvim_list_wins()
						table.insert(wins, 1, vim.api.nvim_get_current_win())
						for _, win in ipairs(wins) do
							local buf = vim.api.nvim_win_get_buf(win)
							if vim.bo[buf].buftype == "" then
								return win
							end
						end
						return 0
					end,
					mappings = {
						i = {
							["<c-t>"] = open_with_trouble,
							["<a-t>"] = open_selected_with_trouble,
							["<a-i>"] = find_files_no_ignore,
							["<a-h>"] = find_files_with_hidden,
							["<C-Down>"] = actions.cycle_history_next,
							["<C-Up>"] = actions.cycle_history_prev,
							["<C-f>"] = actions.preview_scrolling_down,
							["<C-b>"] = actions.preview_scrolling_up,
						},
						n = {
							["q"] = actions.close,
						},
					},
				},
			}
		end,
	},
}
