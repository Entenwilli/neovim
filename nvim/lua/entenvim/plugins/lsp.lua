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
			{ "folke/lazydev.nvim", opts = {} },
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
			folds = {
				enabled = true,
			},

			-- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
			-- Be aware that you also will need to properly configure your LSP server to
			-- provide the inlay hints.
			inlay_hints = {
				enabled = true,
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
				["*"] = {
					capabilities = {
						workspace = {
							fileOperations = {
								didRename = true,
								willRename = true,
							},
						},
					},
					keys = {
						{
							"<leader>cl",
							function()
								Snacks.picker.lsp_config()
							end,
							desc = "Lsp Info",
						},
						{ "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
						{ "gr", vim.lsp.buf.references, desc = "References", nowait = true },
						{ "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
						{ "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
						{ "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
						{
							"K",
							function()
								return vim.lsp.buf.hover()
							end,
							desc = "Hover",
						},
						{
							"gK",
							function()
								return vim.lsp.buf.signature_help()
							end,
							desc = "Signature Help",
							has = "signatureHelp",
						},
						{
							"<c-k>",
							function()
								return vim.lsp.buf.signature_help()
							end,
							mode = "i",
							desc = "Signature Help",
							has = "signatureHelp",
						},
						{
							"<leader>ca",
							vim.lsp.buf.code_action,
							desc = "Code Action",
							mode = { "n", "x" },
							has = "codeAction",
						},
						{
							"<leader>cc",
							vim.lsp.codelens.run,
							desc = "Run Codelens",
							mode = { "n", "x" },
							has = "codeLens",
						},
						{
							"<leader>cC",
							vim.lsp.codelens.refresh,
							desc = "Refresh & Display Codelens",
							mode = { "n" },
							has = "codeLens",
						},
						{
							"<leader>cR",
							function()
								Snacks.rename.rename_file()
							end,
							desc = "Rename File",
							mode = { "n" },
							has = { "workspace/didRenameFiles", "workspace/willRenameFiles" },
						},
						{ "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
						{
							"]]",
							function()
								Snacks.words.jump(vim.v.count1)
							end,
							has = "documentHighlight",
							desc = "Next Reference",
							enabled = function()
								return Snacks.words.is_enabled()
							end,
						},
						{
							"[[",
							function()
								Snacks.words.jump(-vim.v.count1)
							end,
							has = "documentHighlight",
							desc = "Prev Reference",
							enabled = function()
								return Snacks.words.is_enabled()
							end,
						},
						{
							"<a-n>",
							function()
								Snacks.words.jump(vim.v.count1, true)
							end,
							has = "documentHighlight",
							desc = "Next Reference",
							enabled = function()
								return Snacks.words.is_enabled()
							end,
						},
						{
							"<a-p>",
							function()
								Snacks.words.jump(-vim.v.count1, true)
							end,
							has = "documentHighlight",
							desc = "Prev Reference",
							enabled = function()
								return Snacks.words.is_enabled()
							end,
						},
					},
				},
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
				---@diagnostic disable-next-line: missing-fields
				volar = {},
				---@diagnostic disable-next-line: missing-fields
				tailwindcss = {},
				ts_ls = {
					filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
					init_options = {
						plugins = {},
					},
					settings = {},
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
				nixd = {
					mason = false,
					settings = {
						nixd = {
							nixpkgs = {
								expr = 'import (builtins.getFlake "/home/felix/nixos/flake.nix").inputs.nixpkgs { }',
							},
							formatting = {
								command = { "alejandra" },
							},
							options = {
								nixos = {
									expr = '(builtins.getFlake "/home/felix/nixos/flake.nix").nixosConfigurations.desktop.options',
								},
								home_manager = {
									expr = '(builtins.getFlake "/home/felix/nixos/flake.nix").homeConfigurations.desktop.options',
								},
							},
						},
					},
				},
				pylsp = {},
			},
			-- you can do any additional lsp server setup here
			-- return true if you don't want this server to be setup with lspconfig
			---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
			setup = {
				nixd = function(_, opts)
					vim.lsp.enable("nixd")
					return true
				end,
			},
		},
		config = vim.schedule_wrap(function(_, opts)
			-- setup autoformat
			EntenVim.format.register(EntenVim.lsp.formatter())

			-- Setup neoconf
			require("neoconf").setup()
			require("lazydev").setup()

			-- setup keymaps
			for server, server_opts in pairs(opts.servers) do
				if type(server_opts) == "table" and server_opts.keys then
					require("entenvim.plugins.lsp.keymaps").set(
						{ name = server ~= "*" and server or nil },
						server_opts.keys
					)
				end
			end

			-- inlay hints
			if opts.inlay_hints.enabled then
				Snacks.util.lsp.on({ method = "textDocument/inlayHint" }, function(buffer)
					if
						vim.api.nvim_buf_is_valid(buffer)
						and vim.bo[buffer].buftype == ""
						and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
					then
						vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
					end
				end)
			end

			-- folds
			if opts.folds.enabled then
				Snacks.util.lsp.on({ method = "textDocument/foldingRange" }, function() end)
			end

			-- code lens
			if opts.codelens.enabled and vim.lsp.codelens then
				Snacks.util.lsp.on({ method = "textDocument/codeLens" }, function(buffer)
					vim.lsp.codelens.refresh()
					vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
						buffer = buffer,
						callback = vim.lsp.codelens.refresh,
					})
				end)
			end

			-- diagnostics
			if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
				opts.diagnostics.virtual_text.prefix = function(diagnostic)
					local icons = require("entenvim.user.icons")
					for d, icon in pairs(icons) do
						if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
							return icon
						end
					end
					return "●"
				end
			end
			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

			if opts.capabilities then
				EntenVim.deprecate(
					"lsp-config.opts.capabilities",
					"Use lsp-config.opts.servers['*'].capabilities instead"
				)
				opts.servers["*"] = vim.tbl_deep_extend("force", opts.servers["*"] or {}, {
					capabilities = opts.capabilities,
				})
			end

			if opts.servers["*"] then
				vim.lsp.config("*", opts.servers["*"])
			end

			-- get all the servers that are available through mason-lspconfig
			local have_mason = EntenVim.has("mason-lspconfig.nvim")
			local mason_all = have_mason
					and vim.tbl_keys(require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package)
				or {} --[[ @as string[] ]]
			local mason_exclude = {} ---@type string[]

			---@return boolean? exclude automatic setup
			local function configure(server) end

			local install = vim.tbl_filter(configure, vim.tbl_keys(opts.servers))
			if have_mason then
				require("mason-lspconfig").setup({
					ensure_installed = vim.list_extend(
						install,
						EntenVim.opts("mason-lspconfig.nvim").ensure_installed or {}
					),
					automatic_enable = { exclude = mason_exclude },
				})
			end
		end),
	},
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts = {
			PATH = "append",
			ensure_installed = {
				"qmlls",
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
				"vue-language-server",
				"rust-analyzer",
				"python-lsp-server",
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
