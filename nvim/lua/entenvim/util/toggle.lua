---@class entenvim.util.toggle
local M = {}

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.option(option, silent, values)
	if values then
		if vim.opt_local[option]:get() == values[1] then
			---@diagnostic disable-next-line: no-unknown
			vim.opt_local[option] = values[2]
		else
			---@diagnostic disable-next-line: no-unknown
			vim.opt_local[option] = values[1]
		end
	end
	---@diagnostic disable-next-line: no-unknown
	vim.opt_local[option] = not vim.opt_local[option]:get()
end

local nu = { number = true, relativenumber = true }
function M.number()
	if vim.opt_local.number:get() or vim.opt_local.relativenumber:get() then
		nu = { number = vim.opt_local.number:get(), relativenumber = vim.opt_local.relativenumber:get() }
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
	else
		vim.opt_local.number = nu.number
		vim.opt_local.relativenumber = nu.relativenumber
	end
end

local enabled = true
function M.diagnostics()
	-- if this Neovim version supports checking if diagnostics are enabled
	-- then use that for the current state
	if vim.diagnostic.is_enabled then
		enabled = vim.diagnostic.is_enabled()
	elseif vim.diagnostic.is_disabled then
		enabled = not vim.diagnostic.is_disabled()
	end
	enabled = not enabled

	if enabled then
		vim.diagnostic.enable()
	else
		vim.diagnostic.disable()
	end
end

---@param buf? number
---@param value? boolean
function M.inlay_hints(buf, value)
	local ih = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
	if type(ih) == "function" then
		ih(buf, value)
	elseif type(ih) == "table" and ih.enable then
		if value == nil then
			value = not ih.is_enabled({ bufnr = buf or 0 })
		end
		ih.enable(value, { bufnr = buf })
	end
end

setmetatable(M, {
	__call = function(m, ...)
		return m.option(...)
	end,
})

return M
