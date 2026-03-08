local m = vim.keymap.set

-- More usable terminal mode
m("t", "<esc>", "<c-\\><c-n>", { desc = "escape out of terminal mode", noremap = true })

m("n", "gr", vim.lsp.buf.references, { desc = "find symbol references" })
m("n", "gd", vim.lsp.buf.definition, { desc = "find symbol definition" })
m("n", "<leader>m", ":silent make! <bar> copen<cr>", { desc = "make project", silent = true, noremap = true })
m("n", "<leader>td", ":silent grep TODO\\: <bar> copen<cr>", { desc = "grep 'TODO:'s", silent = true, noremap = true })

m("i", "(", "()<left>", { desc = "Auto ()", silent = true, noremap = true })
m("i", "[", "[]<left>", { desc = "Auto []", silent = true, noremap = true })
m("i", "{", "{}<left>", { desc = "Auto {}", silent = true, noremap = true })

vim.api.nvim_create_user_command("CycleIntRepr", function()
	local cword = vim.fn.expand("<cword>")
	if tonumber(cword) == nil then
		return
	end

	local prefix = nil
	local fmt = nil
	if cword:sub(1, 2) == "0x" then
		prefix = "0b"
		fmt = ":b"
	elseif cword:sub(1, 2) == "0b" then
		prefix = ""
		fmt = ""
	else
		prefix = "0x"
		fmt = ":x"
	end

	-- I use python here as they have bigint by default
	local cmd = 'echo "print(f\\"' .. prefix .. "{" .. cword .. fmt .. '}\\")" | python3'
	local out = vim.fn.system(cmd)
	vim.cmd("normal! ciw" .. out)
end, { desc = "Convert (rotate) an int to hex->bin->dec->hex." })

m({ "n", "v" }, "<leader>s", function()
	local name = vim.api.nvim_buf_get_name(0)
	if name == "" then
		pcall(function()
			vim.cmd("saveas " .. vim.fn.input("Save as: ", "", "file"))
		end)
	else
		vim.cmd("silent update")
	end
end, { desc = "Smart write" })

m("n", "<c-f>", "<cmd>on<cr>")
m("n", "<esc>", "<cmd>nohlsearch<cr>")
m("n", "<leader>d", "<cmd>bd<cr>", { noremap = true, silent = true })

m("n", "<c-j>", "<cmd>tabn<cr>", { desc = "next tab" })
m("n", "<c-k>", "<cmd>tabp<cr>", { desc = "previous tab" })

m("n", "<leader>h", "<cmd>split<cr>")
m("n", "<leader>v", "<cmd>vsplit<cr>")
m("n", "<leader>l", "<cmd>Lazy<cr>")
m("n", "<leader>r", vim.lsp.buf.rename, { noremap = true, silent = true })

m("n", "<c-n>", ":silent cnext<cr>")
m("n", "<c-p>", ":silent cprev<cr>")
