local m = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

m("n", "<leader>fh", function()
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
end)

-- Converts a decimal to hex and back again
m("n", "<c-n>", function()
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
m("n", "<leader>fo", "<cmd>FzfLua buffers<cr>", { desc = "Search open buffers" })
m("n", "<leader>fc", "<cmd>FzfLua colorschemes<cr>", { desc = "Ripgrep colorschemes" })
m("n", "<leader>fj", "<cmd>FzfLua zoxide<cr>", { desc = "zoxide projects" })
m("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", { desc = "Search recent files" })
m("n", "<leader>fk", "<cmd>FzfLua keymaps<cr>", { desc = "Search keymaps" })
m("n", "<leader>fm", "<cmd>FzfLua marks<cr>", { desc = "Search marks" })

m("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", { desc = "Find symbol definition", noremap = true, silent = true })
m("n", "gD", "<cmd>FzfLua lsp_declarations<cr>", { desc = "Find symbol declaration", noremap = true, silent = true })
m("n", "gi", "<cmd>FzfLua lsp_implementations<cr>", { desc = "Get lsp impls" })
-- TODO: m("n", "gs", "<cmd>FzfLua<cr>", { desc = "Get lsp something" })
m("n", "<leader>fT", "<cmd>FzfLua diagnostics_workspace<cr>", { desc = "Get trouble for workspace" })
m("n", "<leader>ft", "<cmd>FzfLua diagnostics_document<cr>", { desc = "Get trouble for document" })

m("n", "<leader>r", vim.lsp.buf.rename, { noremap = true, silent = true })
m("n", "<leader>t", vim.lsp.buf.type_definition, { noremap = true, silent = true })

m("n", "<C-f>", "<cmd>on<cr>", { noremap = true, silent = true })

m({ "n", "v" }, "<leader>a", "<cmd>FzfLua lsp_code_actions<cr>")

m("n", "<leader>fh", function()
	require("fzf-lua").help_tags({
		actions = {
			["default"] = function(items)
				local topic = items[1]:match("^[^%s]+")

				-- close any help buffers if they exist?
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					if vim.bo[buf].filetype == "help" then
						vim.api.nvim_buf_delete(buf, {})
					end
				end

				local popup = require("nui.popup")({
					enter = true,
					focusable = true,
					border = { style = "rounded" },
					position = "50%",
					size = { width = "50%", height = "100%" },
					buf_options = { buftype = "help", swapfile = false },
				})

				popup:mount()

				vim.api.nvim_buf_call(popup.bufnr, function()
					vim.cmd("help " .. topic)
				end)

				popup:map("n", "q", function()
					popup:unmount()
				end)
				popup:on("BufLeave", function()
					popup:unmount()
				end, { once = true })
			end,
		},
	})
end, { desc = "Grep neovim help tags into float window" })
