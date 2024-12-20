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

return M
