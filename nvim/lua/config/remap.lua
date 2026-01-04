local m = vim.keymap.set

m("n", "<leader>m", vim.cmd.make, { desc = "runs :make" })
m("n", "gr", vim.lsp.buf.references, { desc = "find symbol references" })
m("n", "gd", vim.lsp.buf.definition, { desc = "find symbol definition" })

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
		pcall(vim.cmd, "saveas " .. vim.fn.input("Save as: ", "", "file"))
	else
		vim.cmd("update")
	end
end, { desc = "Smart write" })

m("n", "<c-f>", "<cmd>on<cr>")
m("n", "<esc>", "<cmd>nohlsearch<cr>")
m("n", "<leader>d", "<cmd>bd<cr>", { noremap = true, silent = true })

m("n", "<tab>", "<cmd>tabn<cr>", { desc = "next tab" })
m("n", "<s-tab>", "<cmd>tabp<cr>", { desc = "previous tab" })

m("n", "<leader>h", "<cmd>split<cr>")
m("n", "<leader>v", "<cmd>vsplit<cr>")
m("n", "<leader>l", "<cmd>Lazy<cr>")
m("n", "<leader>r", vim.lsp.buf.rename, { noremap = true, silent = true })

m("n", "<c-n>", function()
	pcall(vim.cmd.cnext)
end)
m("n", "<c-p>", function()
	pcall(vim.cmd.cprev)
end)
