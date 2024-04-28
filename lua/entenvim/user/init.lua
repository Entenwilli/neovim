_G.EntenVim = require("entenvim.util")

local M = {}

function M.setup(opts)
	local group = vim.api.nvim_create_augroup("EntenVim", { clear = true })
	vim.api.nvim_create_autocmd("User", {
		group = group,
		pattern = "VeryLazy",
		callback = function()
			-- Load autocmds
			-- Load keymaps
			EntenVim.format.setup()

			vim.api.nvim_create_user_command("LazyHealth", function()
				vim.cmd([[Lazy! load all]])
				vim.cmd([[checkhealth]])
			end, { desc = "Load all plugins and run :checkhealth" })
		end,
	})

	-- Make sure colorscheme is loaded
	EntenVim.track("colorscheme")
	EntenVim.try(function()
		if type(M.colorscheme) == "function" then
			M.colorscheme()
		else
			vim.cmd.colorscheme(M.colorscheme)
		end
	end, {
		msg = "Could not load colorscheme",
		on_error = function(msg)
			EntenVim.error(msg)
			vim.cmd.colorscheme("habamax")
		end,
	})
	EntenVim.track()

	require("entenvim.user.options")
	require("entenvim.user.keymaps")
	require("entenvim.user.plugins")

	EntenVim.format.setup()
end

return M
