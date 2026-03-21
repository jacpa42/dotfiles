local autocmd = vim.api.nvim_create_autocmd

-- special commands for dapui buffers
autocmd({ "FileType" }, {
	pattern = { "dap-view", "dap-view-term", "dap-repl" }, -- dap-repl is set by `nvim-dap`
	callback = function(args)
		vim.keymap.set("n", "q", "<C-w>q", { buffer = args.buf })
	end,
})

local function local_disable_spell()
	require("config.opts")
	vim.opt_local.spell = false
	vim.opt_local.spelllang = ""
	vim.opt_local.syntax = "off"
end

-- Disable spell for specific file types
autocmd({ "FileType" }, {
	pattern = { "qf", "json", "man", "confini", "hyprlang", "sshconfig", "sh", "openvpn" },
	callback = local_disable_spell,
})

-- Disable spell for terminal
autocmd({ "TermOpen" }, {
	callback = local_disable_spell,
})

autocmd({ "FileType" }, {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

autocmd({ "FileType" }, {
	pattern = "rust",
	callback = function(args)
		vim.opt_local.errorformat = {
			"%.%# panicked at %f:%l:%c:", -- cargo test
			"%.%# --> %f:%l:%c", -- cargo check/build
			"%.%# --> %f:%l:%c", -- cargo test debug prints
			"%.%# [%f:%l:%c] %.%#", -- cargo test debug prints
		}
		vim.bo[args.buf].makeprg = "cargo c --tests --all-features"
		vim.keymap.set("n", "t", function()
			vim.opt_local.makeprg = 'cargo nextest run --all-features --max-fail="10:immediate"'
			vim.cmd("silent make | copen | cnext")
			local pwd = vim.fn.getcwd()
			local basename = vim.fn.fnamemodify(pwd, ":t")
			os.execute('notify-send -t 5000 -a "' .. basename .. '" "' .. basename .. ' testing compelete"')
		end, { buffer = args.buf, silent = true })
	end,
})

autocmd({ "FileType" }, {
	pattern = "zig",
	callback = function(args)
		vim.bo[args.buf].makeprg = "zig build"
		vim.opt.errorformat = { "%f:%l:%c: %t%*[^:]: %m" }
		vim.keymap.set("n", "t", function()
			vim.opt_local.makeprg = "zig build t --summary new"
			vim.cmd.make()
		end, { buffer = args.buf })
	end,
})

autocmd("TextYankPost", {
	desc = "Highlight when yanking",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank({ timeout = 80 })
	end,
})
