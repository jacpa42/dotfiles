vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)
vim.keymap.set("n", "<leader>l", "<Cmd>Lazy<Cr>")
vim.keymap.set("n", "<leader>d", "<cmd>bd<cr>", { noremap = true, silent = true })

vim.keymap.set("n", "<Esc>", function()
	if vim.v.hlsearch == 1 then
		vim.cmd("noh")
		return ""
	else
		return "<Esc>"
	end
end, { expr = true, noremap = true, silent = true })

vim.keymap.set({ "n", "i", "v" }, "<c-s>", "<Cmd>wa<Cr>")

vim.keymap.set("n", "<leader><leader>", "<Cmd>FzfLua files<Cr>")
vim.keymap.set("n", "<leader>ff", "<Cmd>FzfLua live_grep_glob<Cr>")
vim.keymap.set({ "n", "v" }, "<leader>ca", "<Cmd>FzfLua lsp_code_actions<Cr>")
vim.keymap.set("n", "<leader>fc", "<Cmd>FzfLua grep_curbuf<Cr>")

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>t", vim.lsp.buf.type_definition, { noremap = true, silent = true })

vim.keymap.set("n", "<C-j>", "<Cmd>wincmd j<Cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<Cmd>wincmd k<Cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-h>", "<Cmd>wincmd h<Cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<Cmd>wincmd l<Cr>", { noremap = true, silent = true })

vim.keymap.set("n", "<C-f>", "<Cmd>%bd|e#<Cr>", { noremap = true, silent = true })
