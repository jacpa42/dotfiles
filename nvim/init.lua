require("config.remap")
require("config.lazy")
require("config.opts")
require("config.autocmd")

-- Base ones i always need
vim.lsp.enable({ "clangd", "luals", "rust_analyzer" })

-- Hyprland configuration file lsp
vim.lsp.enable({ "hyprls" })

-- Python
vim.lsp.enable({ "basedpyright", "ruff" })
