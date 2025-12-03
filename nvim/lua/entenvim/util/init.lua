local LazyUtil = require("lazy.core.util")

---@class util: LazyUtilCore
---@field format entenvim.util.format
---@field plugin entenvim.util.plugin
---@field lsp entenvim.util.lsp
---@field telescope entenvim.util.telescope
---@field toggle entenvim.util.toggle
---@field mini entenvim.util.mini
local M = {}

setmetatable(M, {
	__index = function(t, k)
		-- Use utils from lazy
		if LazyUtil[k] then
			return LazyUtil[k]
		end

		-- Use local utils
		t[k] = require("entenvim.util." .. k)
		return t[k]
	end,
})

--@param plugin string
function M.has(plugin)
	return require("lazy.core.config").spec.plugins[plugin] ~= nil
end
---@param opts? LazyNotifyOpts
function M.deprecate(old, new, opts)
	M.warn(
		("`%s` is deprecated. Please use `%s` instead"):format(old, new),
		vim.tbl_extend("force", {
			title = "LazyVim",
			once = true,
			stacktrace = true,
			stacklevel = 6,
		}, opts or {})
	)
end
--@param fn fun()
function M.on_very_lazy(fn)
	vim.api.nvim_create_autocmd("User", {
		pattern = "VeryLazy",
		callback = function()
			fn()
		end,
	})
end

function M.opts(name)
	local plugin = require("lazy.core.config").plugins[name]
	if not plugin then
		return {}
	end
	local Plugin = require("lazy.core.plugin")
	return Plugin.values(plugin, "opts", false)
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
	local Config = require("lazy.core.config")
	if Config.plugins[name] and Config.plugins[name]._.loaded then
		fn(name)
	else
		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyLoad",
			callback = function(event)
				if event.data == name then
					fn(name)
					return true
				end
			end,
		})
	end
end

-- Wrapper around vim.keymap.set that will
-- not create a keymap if a lazy key handler exists.
-- It will also set `silent` to true by default.
function M.safe_keymap_set(mode, lhs, rhs, opts)
	local keys = require("lazy.core.handler").handlers.keys
	---@cast keys LazyKeysHandler
	local modes = type(mode) == "string" and { mode } or mode

	---@param m string
	modes = vim.tbl_filter(function(m)
		return not (keys.have and keys:have(lhs, m))
	end, modes)

	-- do not create the keymap if a lazy keys handler exists
	if #modes > 0 then
		opts = opts or {}
		opts.silent = opts.silent ~= false
		if opts.remap and not vim.g.vscode then
			---@diagnostic disable-next-line: no-unknown
			opts.remap = nil
		end
		vim.keymap.set(modes, lhs, rhs, opts)
	end
end

return M
