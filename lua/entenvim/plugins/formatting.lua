local M = {}

---@param opts ConformOpts
function M.setup(_, opts)
	for name, formatter in pairs(opts.formatters or {}) do
		if type(formatter) == "table" then
			---@diagnostic disable-next-line: undefined-field
			if formatter.extra_args then
				---@diagnostic disable-next-line: undefined-field
				formatter.prepend_args = formatter.extra_args
			end
		end
	end
	require("conform").setup(opts)
end

return {
	{
		"stevearc/conform.nvim",
		dependencies = { "mason.nvim" },
		lazy = true,
		cmd = "ConformInfo",
		keys = {
			{
				"<leader>cF",
				function()
					require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
				end,
				mode = { "n", "v" },
				desc = "Format Injected Langs",
			},
		},
		init = function()
			-- Install the conform formatter on VeryLazy
			EntenVim.format.register({
				name = "conform.nvim",
				priority = 100,
				primary = true,
				format = function(buf)
					local plugin = require("lazy.core.config").plugins["conform.nvim"]
					local Plugin = require("lazy.core.plugin")
					local opts = Plugin.values(plugin, "opts", false)
					require("conform").format(require("lazy.core.util").merge({}, opts.format, { bufnr = buf }))
				end,
				sources = function(buf)
					local ret = require("conform").list_formatters(buf)
					---@param v conform.FormatterInfo
					return vim.tbl_map(function(v)
						return v.name
					end, ret)
				end,
			})
		end,
		opts = function()
			---@class ConformOpts
			local opts = {
				log_level = vim.log.levels.DEBUG,
				-- LazyVim will use these options when formatting with the conform.nvim formatter
				format = {
					timeout_ms = 3000,
					async = false, -- not recommended to change
					quiet = false, -- not recommended to change
					lsp_fallback = true, -- not recommended to change
				},
				---@type table<string, conform.FormatterUnit[]>
				formatters_by_ft = {
					lua = { "stylua" },
					fish = { "fish_indent" },
					sh = { "shfmt" },
					javascript = { "prettierd" },
					nix = { "alejandra" },
					latex = { "latex_fmt" },
					tex = { "latex_fmt" },
					plaintex = { "latex_fmt" },
				},
				-- The options you set here will be merged with the builtin formatters.
				-- You can also define any custom formatters here.
				---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
				formatters = {
					latex_fmt = {
						command = "latexindent.pl",
						args = { "-" },
						stdin = true,
					},
					injected = { options = { ignore_errors = true } },
					-- # Example of using dprint only when a dprint.json file is present
					-- dprint = {
					--   condition = function(ctx)
					--     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
					--   end,
					-- },
					--
					-- # Example of using shfmt with extra args
					-- shfmt = {
					--   prepend_args = { "-i", "2", "-ci" },
					-- },
				},
			}
			return opts
		end,
		config = M.setup,
	},
}
