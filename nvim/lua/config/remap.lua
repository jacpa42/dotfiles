vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>")
vim.keymap.set("n", "<leader>d", "<cmd>bd<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { noremap = true, silent = true })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")

vim.keymap.set({ "n", "v" }, "<leader>s", "<cmd>w<cr>")

vim.keymap.set("n", "<leader><leader>", "<cmd>FzfLua files<cr>")
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua live_grep<cr>")
vim.keymap.set("n", "<leader>fd", "<cmd>FzfLua buffers<cr>", { desc = "Grep buffers" })

vim.keymap.set("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "gi", "<cmd>FzfLua lsp_implementations<cr>", { desc = "Grep lsp impls" })

vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>t", vim.lsp.buf.type_definition, { noremap = true, silent = true })

vim.keymap.set("n", "<C-j>", "<cmd>wincmd j<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<cmd>wincmd k<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-h>", "<cmd>wincmd h<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<cmd>wincmd l<cr>", { noremap = true, silent = true })

vim.keymap.set("n", "<C-f>", "<cmd>on<cr>", { noremap = true, silent = true })

vim.keymap.set({ "n", "v" }, "<leader>a", "<cmd>FzfLua lsp_code_actions<cr>")

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ timeout = 100 })
	end,
})

vim.keymap.set("n", "<leader>td", "<cmd>TodoQuickFix<cr>")
