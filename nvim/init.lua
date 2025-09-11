require("config.remap")
require("config.lazy")
require("config.opts")
require("config.autocmd")
require("config.status")
require("config.greet")

-- Based ones I always need
vim.lsp.enable({ "clangd", "luals", "rust_analyzer" })

-- Hyprland configuration file lsp
vim.lsp.enable({ "hyprls" })

-- zig language server
vim.lsp.enable({ "zls" })
