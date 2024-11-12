local languages = {}

languages.dictionaries = {
	["en-US"] = { vim.fn.stdpath("data") .. "/spell/en.txt" },
	["de-DE"] = { vim.fn.stdpath("data") .. "/spell/de.txt" },
}

-- function to avoid interacting with the table directly
function languages.getDictFiles(lang)
	local files = languages.dictionaries[lang]
	if files then
		return files
	else
		return nil
	end
end

-- combine words from all the files. Each line should contain one word
function languages.readDictFiles(lang)
	local files = languages.getDictFiles(lang)
	local dict = {}
	if files then
		for _, file in ipairs(files) do
			local f = io.open(file, "r")
			if f then
				for l in f:lines() do
					table.insert(dict, l)
				end
			else
				print("Can not read dict file %q", file)
			end
		end
	else
		print("Lang %q has no files", lang)
	end
	return dict
end

-- Append words to the last element of the language files
function languages.addWordsToFiles(lang, words)
	local files = languages.getDictFiles(lang)
	if not files then
		return print("no dictionary file defined for lang %q", lang)
	else
		local file = io.open(files[#files - 0], "a+")
		if file then
			for _, word in ipairs(words) do
				file:write(word .. "\n")
			end
			file:close()
		else
			return print("Failed insert %q", vim.inspect(words))
		end
	end
end

local function on_attach(client, _)
	local addToDict = function(command, _)
		for _, arg in ipairs(command.arguments) do
			for lang, words in pairs(arg.words) do
				languages.addWordsToFiles(lang, words)
				client.config.settings.ltex.dictionary = {
					[lang] = languages.readDictFiles(lang),
				}
			end
		end
		return client.notify("workspace/didChangeConfiguration", client.config.settings)
	end
	vim.lsp.commands["_ltex.addToDictionary"] = addToDict
end

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
			{ "folke/neodev.nvim", opts = {} },
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"folke/neoconf.nvim",
		},
		---@class PluginLspOpts
		opts = {
			-- options for vim.diagnostic.config()
			---@type vim.diagnostic.Opts
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					-- this will set set the prefix to a function that returns the diagnostics icon based on the severity
					-- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
					prefix = "icons",
				},
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "",
						[vim.diagnostic.severity.INFO] = "",
					},
				},
			},
			-- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
			-- Be aware that you also will need to properly configure your LSP server to
			-- provide the inlay hints.
			inlay_hints = {
				enabled = false,
			},
			-- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
			-- Be aware that you also will need to properly configure your LSP server to
			-- provide the code lenses.
			codelens = {
				enabled = true,
			},
			-- Enable lsp cursor word highlighting
			document_highlight = {
				enabled = true,
			},
			-- add any global capabilities here
			capabilities = {
				workspace = {
					fileOperations = {
						didRename = true,
						willRename = true,
					},
				},
			},
			-- options for vim.lsp.buf.format
			-- `bufnr` and `filter` is handled by the EntenVim  formatter,
			-- but can be also overridden when specified
			format = {
				formatting_options = nil,
				timeout_ms = nil,
			},
			-- LSP Server Settings
			---@type lspconfig.options
			---@diagnostic disable-next-line: missing-fields
			servers = {
				lua_ls = {
					settings = {
						---@diagnostic disable-next-line: missing-fields
						Lua = {
							---@diagnostic disable-next-line: missing-fields
							hint = {
								enable = true,
								setType = false,
								paramType = true,
								paramName = "Disable",
								semicolon = "Disable",
								arrayIndex = "Disable",
							},
							---@diagnostic disable-next-line: missing-fields
							doc = {
								privateName = { "^_" },
							},
							---@diagnostic disable-next-line: missing-fields
							workspace = {
								checkThirdParty = false,
							},
							---@diagnostic disable-next-line: missing-fields
							codeLens = {
								enable = true,
							},
							---@diagnostic disable-next-line: missing-fields
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
				clangd = {
					settings = {
						---@diagnostic disable-next-line: missing-fields
						clangd = {
							---@diagnostic disable-next-line: missing-fields
							InlayHints = {
								Designators = true,
								Enabled = true,
								ParameterNames = true,
								DeducedTypes = true,
							},
							fallbackFlags = { "-std=c++20" },
						},
					},
				},
				ts_ls = {
					settings = {
						---@diagnostic disable-next-line: missing-fields
						typescript = {
							---@diagnostic disable-next-line: missing-fields
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = true,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayVariableTypeHintsWhenTypeMatchesName = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
						---@diagnostic disable-next-line: missing-fields
						javascript = {
							---@diagnostic disable-next-line: missing-fields
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = true,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayVariableTypeHintsWhenTypeMatchesName = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
					},
				},
				ltex = {
					on_attach = on_attach,
					settings = {
						---@diagnostic disable-next-line: missing-fields
						ltex = {
							language = "en-US",
							---@diagnostic disable-next-line: missing-fields
							dictionary = {
								["en-US"] = languages.readDictFiles("en-US"),
								["de-DE"] = languages.readDictFiles("de-DE"),
							},
							additionalrules = {
								enablepickyrules = true,
								mothertongue = "de",
							},
							completionenabled = true,
						},
					},
				},
				nil_ls = {},
			},
			-- you can do any additional lsp server setup here
			-- return true if you don't want this server to be setup with lspconfig
			---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
			setup = {},
		},
		---@param opts PluginLspOpts
		config = function(_, opts)
			-- setup autoformat
			EntenVim.format.register(EntenVim.lsp.formatter())

			-- Setup neoconf
			require("neoconf").setup()
			require("neodev").setup()

			-- setup keymaps
			EntenVim.lsp.on_attach(function(client, buffer)
				require("entenvim.user.keymaps").on_attach(client, buffer)
			end)

			EntenVim.lsp.setup()
			EntenVim.lsp.on_dynamic_capability(require("entenvim.user.keymaps").on_attach)

			EntenVim.lsp.words.setup(opts.document_highlight)

			local register_capability = vim.lsp.handlers["client/registerCapability"]

			---@diagnostic disable-next-line: duplicate-set-field
			vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
				---@diagnostic disable-next-line: no-unknown
				local ret = register_capability(err, res, ctx)
				local client = vim.lsp.get_client_by_id(ctx.client_id)
				local buffer = vim.api.nvim_get_current_buf()
				require("entenvim.user.keymaps").on_attach(client, buffer)
				return ret
			end

			-- diagnostics signs
			if vim.fn.has("nvim-0.10.0") == 0 then
				for severity, icon in pairs(opts.diagnostics.signs.text) do
					local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
					name = "DiagnosticSign" .. name
					vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
				end
			end

			-- inlay hints
			if opts.inlay_hints.enabled then
				EntenVim.lsp.on_attach(function(client, buffer)
					if client.supports_method("textDocument/inlayHint") then
						EntenVim.toggle.inlay_hints(buffer, true)
					end
				end)
			end

			-- code lens
			if opts.codelens.enabled and vim.lsp.codelens then
				EntenVim.lsp.on_attach(function(client, buffer)
					if client.supports_method("textDocument/codeLens") then
						vim.lsp.codelens.refresh()
						--- autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()
						vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
							buffer = buffer,
							callback = vim.lsp.codelens.refresh,
						})
					end
				end)
			end

			if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
				opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
					or function(diagnostic)
						local icons = require("entenvim.user.icons").diagnostics
						for d, icon in pairs(icons) do
							if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
								return icon
							end
						end
					end
			end

			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

			-- get all the servers that are available through mason-lspconfig
			local servers = opts.servers
			local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				has_cmp and cmp_nvim_lsp.default_capabilities() or {},
				opts.capabilities or {}
			)

			local function setup(server)
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(capabilities),
				}, servers[server] or {})

				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return
					end
				elseif opts.setup["*"] then
					if opts.setup["*"](server, server_opts) then
						return
					end
				end
				require("lspconfig")[server].setup(server_opts)
			end

			-- get all the servers that are available through mason-lspconfig
			local have_mason, mlsp = pcall(require, "mason-lspconfig")
			local all_mslp_servers = {}
			if have_mason then
				all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
			end

			local ensure_installed = {} ---@type string[]
			for server, server_opts in pairs(servers) do
				if server_opts then
					server_opts = server_opts == true and {} or server_opts
					if server_opts.enabled ~= false then
						-- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
						if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
							setup(server)
						else
							ensure_installed[#ensure_installed + 1] = server
						end
					end
				end
			end

			if have_mason then
				mlsp.setup({
					ensure_installed = vim.tbl_deep_extend(
						"force",
						ensure_installed,
						EntenVim.opts("mason-lspconfig.nvim").ensure_installed or {}
					),
					handlers = { setup },
				})
			end

			if EntenVim.lsp.is_enabled("denols") and EntenVim.lsp.is_enabled("vtsls") then
				local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
				EntenVim.lsp.disable("vtsls", is_deno)
				EntenVim.lsp.disable("denols", function(root_dir, config)
					if not is_deno(root_dir) then
						config.settings.deno.enable = false
					end
					return false
				end)
			end
		end,
	},
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts = {
			PATH = "append",
			ensure_installed = {
				"astro-language-server",
				"bash-language-server",
				"clangd",
				"dockerfile-language-server",
				"html-lsp",
				"latexindent",
				"ltex-ls",
				"lua-language-server",
				"nil",
				"stylua",
				"shfmt",
				"tailwindcss-language-server",
				"texlab",
				"typescript-language-server",
				"jdtls",
				"json-lsp",
			},
		},
		---@param opts MasonSettings | {ensure_installed: string[]}
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			local mason_registry = require("mason-registry")
			mason_registry:on("package:install:success", function(pkg)
				pkg:get_receipt():if_present(function(receipt)
					for _, rel_path in pairs(receipt.links.bin) do
						local bin_abs_path = pkg:get_install_path() .. "/extension/server/bin/" .. rel_path
						os.execute(
							'patchelf --set-interpreter "$(patchelf --print-interpreter $(grep -oE \\/nix\\/store\\/[a-z0-9]+-neovim-unwrapped-[0-9]+\\.[0-9]+\\.[0-9]+\\/bin\\/nvim $(which nvim)))" '
								.. bin_abs_path
						)
					end
				end)
			end)
			local function ensure_installed()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end
			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},
	{
		"mfussenegger/nvim-dap",
		recommended = true,
		desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

		dependencies = {
			"rcarriga/nvim-dap-ui",
			-- virtual text for the debugger
			{
				"theHamsta/nvim-dap-virtual-text",
				opts = {},
			},
		},

  -- stylua: ignore
  keys = {
    { "<leader>d", "", desc = "+debug", mode = {"n", "v"} },
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
    { "<leader>dj", function() require("dap").down() end, desc = "Down" },
    { "<leader>dk", function() require("dap").up() end, desc = "Up" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
    { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
    { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end, desc = "Session" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    { "<leader>td", function() require("neotest").run.run({strategy = "dap", suite = false}) end, desc = "Debug Nearest" },
  },

		config = function()
			-- load mason-nvim-dap here, after all adapters have been setup
			require("mason-nvim-dap").setup(EntenVim.opts("mason-nvim-dap.nvim"))

			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

			-- setup dap config by VsCode launch.json file
			local vscode = require("dap.ext.vscode")
			local json = require("plenary.json")
			---@diagnostic disable-next-line: duplicate-set-field
			vscode.json_decode = function(str)
				return vim.json.decode(json.json_strip_comments(str, {}))
			end
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		opts = {},
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "nvim-neotest/nvim-nio" },
  -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
    },
		opts = {},
		config = function(_, opts)
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup(opts)
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end
		end,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = "mason.nvim",
		cmd = { "DapInstall", "DapUninstall" },
		opts = {
			automatic_installation = true,
			handlers = {},
			ensure_installed = {},
		},
		config = function() end,
	},
}
