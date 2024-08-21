-- Keymaps are automatically loaded on the VeryLazy event

local map = vim.keymap.set

map("n", "<C-f>", "<cmd>on<cr>", { desc = "Focus current window" })

map("n", "<leader>ch", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })
