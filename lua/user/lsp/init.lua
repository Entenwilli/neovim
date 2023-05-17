local status, _ = pcall(require, 'lspconfig')
if (not status) then return end

require 'user.lsp.mason'
require('user.lsp.handlers').setup()
require 'user.lsp.null-ls'
