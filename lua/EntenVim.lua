-- Ensure uv is loaded
vim.uv = vim.uv or vim.loop

-- Setup lazy
require("entenvim.user.lazy")

-- Load user configuration
require("entenvim.user").setup()

require("entenvim.user.formatterutils").setup()
