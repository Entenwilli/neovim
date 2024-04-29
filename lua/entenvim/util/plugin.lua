---@class entenvim.util.plugin
local M = {}
M.lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

function M.setup()
	M.register_lazy_file_event()
end

function M.register_lazy_file_event()
	local Event = require("lazy.core.handler.event")
	Event.mappings.LazyFile = {
		id = "LazyFile",
		event = "User",
		pattern = "LazyFile",
	}
	Event.mappings["User LazyFile"] = Event.mappings.LazyFile

	local events = {}

	local done = false
	local function load()
		if #events == 0 or done then
			return
		end
		done = true
		vim.api.nvim_del_augroup_by_name("lazy_file")

		local skips = {}
		for _, event in ipairs(events) do
			skips[event.event] = skips[event.event] or Event.get_augroups(event.event)
		end

		vim.api.nvim_exec_autocmds("User", { pattern = "LazyFile", modeline = false })
		for _, event in ipairs(events) do
			if vim.api.nvim_buf_is_valid(event.buf) then
				Event.trigger({
					event = event.event,
					exclude = skips[event.event],
					data = event.data,
					buf = event.buf,
				})
				if vim.bo[event.buf].filetype then
					Event.trigger({
						event = "FileType",
						buf = event.buf,
					})
				end
			end
		end
		vim.api.nvim_exec_autocmds("CursorMoved", { modeline = false })
		events = {}
	end

	load = vim.schedule_wrap(load)

	vim.api.nvim_create_autocmd(M.lazy_file_events, {
		group = vim.api.nvim_create_augroup("lazy_file", { clear = true }),
		callback = function(event)
			table.insert(events, event)
			load()
		end,
	})
end

return M
