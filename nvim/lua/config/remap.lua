vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)
vim.keymap.set("n", "<leader>l", "<Cmd>Lazy<Cr>")
vim.keymap.set("n", "<c-s>", "<Cmd>wa<Cr>")

----------------------- Fzf lua keymaps -----------------------

vim.keymap.set("n", "<leader><leader>", "<Cmd>FzfLua files<Cr>")
vim.keymap.set("n", "<leader>ff", "<Cmd>FzfLua live_grep_glob<Cr>")
vim.keymap.set("n", "<leader>fa", "<Cmd>FzfLua grep_quickfix<Cr>")
vim.keymap.set("n", "<leader>fc", "<Cmd>FzfLua grep_curbuf<Cr>")

---------------------------------------------------------------
