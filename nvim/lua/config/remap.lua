local m = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

m("n", "<leader>e", function()
	local buf_path = vim.fn.expand("%:p:h")
	if buf_path ~= "" then
		vim.cmd("edit " .. buf_path)
	else
		vim.cmd("edit .")
	end
end)

m("n", "<leader>v", "<cmd>vsplit<cr>")
m("n", "<leader>h", "<cmd>split<cr>")

m("n", "<leader>l", "<cmd>Lazy<cr>")
m("n", "<leader>d", "<cmd>bd<cr>", { noremap = true, silent = true })
m("n", "<Esc>", "<cmd>nohlsearch<cr>")

m({ "n", "v" }, "<leader>s", function()
	local name = vim.api.nvim_buf_get_name(0)
	if name == "" then
		pcall(vim.cmd, "saveas " .. vim.fn.input("Save as: ", "", "file"))
	else
		vim.cmd("w")
	end
end, { desc = "Smart write" })

m("n", "<leader><leader>", "<cmd>FzfLua files<cr>", { desc = "Ripgrep cwd" })
m("n", "<leader>ff", "<cmd>FzfLua live_grep<cr>", { desc = "Ripgrep cwd" })
m("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", { desc = "Ripgrep cwd" })
m("n", "<leader>fc", "<cmd>FzfLua colorschemes<cr>", { desc = "Ripgrep colorschemes" })
m("n", "<leader>fj", "<cmd>FzfLua zoxide<cr>", { desc = "Jump to directory with zoxide" })
m("n", "<leader>fk", "<cmd>FzfLua keymaps<cr>", { desc = "Jump to directory with zoxide" })
m("n", "<leader>fee", "<cmd>Emoji insert<cr>", { desc = "Fuzzy search emojis" })
m("n", "<leader>fek", "<cmd>Emoji kaomoji<cr>", { desc = "Fuzzy search kaomojis" })

m("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", { desc = "Find symbol definition", noremap = true, silent = true })
m("n", "gi", "<cmd>FzfLua lsp_implementations<cr>", { desc = "Get lsp impls" })
m("n", "<leader>fT", "<cmd>FzfLua diagnostics_workspace<cr>", { desc = "Get trouble for workspace" })
m("n", "<leader>ft", "<cmd>FzfLua diagnostics_document<cr>", { desc = "Get trouble for document" })

m("n", "<leader>r", vim.lsp.buf.rename, { noremap = true, silent = true })
m("n", "<leader>t", vim.lsp.buf.type_definition, { noremap = true, silent = true })

m("n", "<M-j>", "<cmd>lua require('tmux').move_bottom()<cr>", { noremap = true, silent = true })
m("n", "<M-k>", "<cmd>lua require('tmux').move_top()<cr>", { noremap = true, silent = true })
m("n", "<M-h>", "<cmd>lua require('tmux').move_left()<cr>", { noremap = true, silent = true })
m("n", "<M-l>", "<cmd>lua require('tmux').move_right()<cr>", { noremap = true, silent = true })

m("n", "<C-f>", "<cmd>on<cr>", { noremap = true, silent = true })

m({ "n", "v" }, "<leader>a", "<cmd>FzfLua lsp_code_actions<cr>")

-- cmd history
m({ "n" }, "<leader>fh", "<cmd>FzfLua command_history<cr>")
