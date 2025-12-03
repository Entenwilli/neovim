return {
	-- Extend auto completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{
				"Saecki/crates.nvim",
				event = { "BufRead Cargo.toml" },
				opts = {
					lsp = {
						enabled = true,
						actions = true,
						completion = true,
						hover = true,
					},
				},
			},
		},
	},
}
