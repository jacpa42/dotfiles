local map = vim.keymap.set

-- More usable terminal mode
map("t", "<esc>", "<c-\\><c-n>", { desc = "escape out of terminal mode", noremap = true })

map("n", "gr", vim.lsp.buf.references, { desc = "find symbol references" })
map("n", "gd", vim.lsp.buf.definition, { desc = "find symbol definition" })

map("n", "<leader>m", "<cmd>make <bar> copen<cr>", { desc = "make project", noremap = true })
map("n", "<leader>M", function()
	local makecmd = vim.fn.input("edit makeprg=", vim.o.makeprg, "file")
	if makecmd:len() > 0 then
		print('makecmd = "' .. makecmd .. '"')
		vim.o.makeprg = makecmd
	end
end, { desc = "set make cmd for project", noremap = true })

map(
	"n",
	"<leader>td",
	"<cmd>silent grep TODO\\: <bar> copen<cr>",
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
		fmt = "<cmd>b"
	elseif cword:sub(1, 2) == "0b" then
		prefix = ""
		fmt = ""
	else
		prefix = "0x"
		fmt = "<cmd>x"
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

map("n", "<c-f>", "<cmd>on<cr>", { noremap = true, silent = true })
map("n", "<esc>", "<cmd>nohl<cr>", { noremap = true, silent = true })
map("n", "<leader>d", "<cmd>bd<cr>", { noremap = true, silent = true })

map("n", "<c-j>", "<cmd>tabn<cr>", { desc = "next tab" })
map("n", "<c-k>", "<cmd>tabp<cr>", { desc = "previous tab" })

map("n", "<leader>h", "<cmd>split<cr>")
map("n", "<leader>v", "<cmd>vsplit<cr>")
map("n", "<leader>l", "<cmd>Lazy<cr>")
map("n", "<leader>r", vim.lsp.buf.rename, { noremap = true, silent = true })

map("n", "<c-n>", "<cmd>cnext<cr>", { noremap = true, silent = true })
map("n", "<c-p>", "<cmd>cprev<cr>", { noremap = true, silent = true })

map("n", ";", "q:", { desc = "command history" })
