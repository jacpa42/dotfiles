local map = vim.keymap.set

-- More usable terminal mode
map("t", "<esc>", "<c-\\><c-n>", { desc = "escape out of terminal mode", noremap = true })

map("n", "gr", vim.lsp.buf.references, { desc = "find symbol references" })
map("n", "gd", vim.lsp.buf.definition, { desc = "find symbol definition" })

map("n", "<leader>m", ":silent make! <bar> copen<cr>", { desc = "make project", silent = true, noremap = true })
map(
	"n",
	"<leader>td",
	":silent grep TODO\\: <bar> copen<cr>",
	{ desc = "grep 'TODO:'s", silent = true, noremap = true }
)

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

map({ "n", "v" }, "<leader>s", function()
	local name = vim.api.nvim_buf_get_name(0)
	if name == "" then
		pcall(function()
			vim.cmd("saveas " .. vim.fn.input("Save as: ", "", "file"))
		end)
	else
		vim.cmd("silent update")
	end
end, { desc = "Smart write" })

map("n", "<c-f>", "<cmd>on<cr>")
map("n", "<esc>", "<cmd>nohlsearch<cr>")
map("n", "<leader>d", "<cmd>bd<cr>", { noremap = true, silent = true })

map("n", "<c-j>", "<cmd>tabn<cr>", { desc = "next tab" })
map("n", "<c-k>", "<cmd>tabp<cr>", { desc = "previous tab" })

map("n", "<leader>h", "<cmd>split<cr>")
map("n", "<leader>v", "<cmd>vsplit<cr>")
map("n", "<leader>l", "<cmd>Lazy<cr>")
map("n", "<leader>r", vim.lsp.buf.rename, { noremap = true, silent = true })

map("n", "<c-n>", ":silent cnext<cr>")
map("n", "<c-p>", ":silent cprev<cr>")

map("n", ";", "q:", { desc = "code actions" })
