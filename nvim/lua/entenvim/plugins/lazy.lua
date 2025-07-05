return {
	{
		"folke/lazy.nvim",
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			indent = { enabled = true },
			input = { enabled = true },
			notifier = { enabled = true },
			scope = { enabled = true },
			scroll = { enabled = true },
			statuscolumn = { enabled = false }, -- we set this in options.lua
			toggle = { map = EntenVim.safe_keymap_set },
			words = { enabled = true },
			dashboard = {
				preset = {
					header = [[
      ███████╗███╗   ██╗████████╗███████╗███╗   ██╗██╗   ██╗██╗███╗   ███╗
      ██╔════╝████╗  ██║╚══██╔══╝██╔════╝████╗  ██║██║   ██║██║████╗ ████║
      █████╗  ██╔██╗ ██║   ██║   █████╗  ██╔██╗ ██║██║   ██║██║██╔████╔██║
      ██╔══╝  ██║╚██╗██║   ██║   ██╔══╝  ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
      ███████╗██║ ╚████║   ██║   ███████╗██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
      ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
      ]],
          -- stylua: ignore
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "p", desc = "Projects", action = ":NeovimProjectDiscover"},
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session", action = ":NeovimProjectLoadRecent" },
            { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
				},
			},
		},
    -- stylua: ignore
    keys = {
      { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "<leader>gg", function() Snacks.terminal({ "lazygit" }) end, desc = "Open lazygit" },
      { "<leader>tf", function() Snacks.terminal({"fish"}) end, desc = "Open floating terminal"} ,
    },
		config = function(_, opts)
			local notify = vim.notify
			require("snacks").setup(opts)
			-- HACK: restore vim.notify after snacks setup and let noice.nvim take over
			-- this is needed to have early notifications show up in noice history
			if EntenVim.has("noice.nvim") then
				vim.notify = notify
			end
		end,
	},
}
