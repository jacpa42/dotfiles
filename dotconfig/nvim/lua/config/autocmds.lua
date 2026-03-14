-- special commands for dapui buffers
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "dap-view", "dap-view-term", "dap-repl" }, -- dap-repl is set by `nvim-dap`
	callback = function(args)
		vim.keymap.set("n", "q", "<C-w>q", { buffer = args.buf })
	end,
})

local function disablespell()
	vim.opt_local.spell = false
	vim.opt_local.spelllang = ""
	vim.opt_local.syntax = "off"
end

-- Disable spell for specific file types
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "qf", "json", "man", "confini", "hyprlang", "sshconfig", "sh" },
	callback = disablespell,
})

-- Disable spell for terminal
vim.api.nvim_create_autocmd({ "TermOpen" }, {
	callback = disablespell,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = "rust",
	callback = function(args)
		vim.bo[args.buf].makeprg = "cargo c --tests --all-features"
		vim.bo[args.buf].errorformat = vim.bo[args.buf].errorformat .. ",.* panicked at %f:%l:%c:"
		vim.notify_once("Setting keymap `<leader>T` to make cargo tests", vim.log.levels.INFO)
		vim.keymap.set("n", "<leader>T", function()
			local makeprg = vim.o.makeprg
			vim.o.makeprg = "cargo t --all-features --color=never"
			pcall(vim.cmd.make)
			vim.o.makeprg = makeprg
		end, { buffer = args.buf })
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = "zig",
	callback = function(args)
		vim.bo[args.buf].makeprg = "zig build"
		vim.bo[args.buf].errorformat = vim.bo[args.buf].errorformat .. "%f:%l:%c: %t%*[^:]: %m"
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank({ timeout = 80 })
	end,
})
