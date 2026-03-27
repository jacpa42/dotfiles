local autocmd = vim.api.nvim_create_autocmd

local function starts_with(str, prefix)
	return string.sub(str, 1, string.len(prefix)) == prefix
end

local function buf_disable_spell()
	vim.o.spell = false
	vim.o.spelllang = ""
end

local function buf_enable_spell()
	vim.o.spell = true
	vim.o.spelllang = "en_gb"
end

function BufToggleSpell()
	require("config.opts")
	if vim.o.spell then
		buf_disable_spell()
	else
		buf_enable_spell()
	end
end

-- special commands for dapui buffers
autocmd({ "FileType" }, {
	pattern = { "dap-view", "dap-view-term", "dap-repl" }, -- dap-repl is set by `nvim-dap`
	callback = function(args)
		vim.keymap.set("n", "q", "<C-w>q", { buffer = args.buf })
	end,
})

-- Disable spell for specific file types
autocmd({ "FileType" }, {
	pattern = { "qf", "json", "man", "confini", "hyprlang", "sshconfig", "sh", "openvpn", "zathurarc" },
	callback = buf_disable_spell,
})

-- Disable spell for terminal
autocmd({ "TermOpen" }, {
	callback = buf_disable_spell,
})

autocmd({ "FileType" }, {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

autocmd({ "FileType" }, {
	pattern = "rust",
	callback = function(args)
		local compile = "cargo c --tests --all-features"
		local test = 'cargo nextest run --all-features --max-fail="10:immediate"'

		vim.o.makeprg = not starts_with(vim.o.makeprg, "cargo") and compile or vim.o.makeprg
		vim.opt_local.errorformat = {
			"%.%# panicked at %f:%l:%c:", -- cargo test
			"%.%# --> %f:%l:%c", -- cargo check/build
			"%.%# --> %f:%l:%c", -- cargo test debug prints
			"%.%# [%f:%l:%c] %.%#", -- cargo test debug prints
		}

		vim.keymap.set("n", "t", function()
			vim.o.makeprg = starts_with(vim.o.makeprg, "cargo c") and test or compile
			vim.notify("makeprg is now " .. vim.o.makeprg, vim.log.levels.INFO)
		end, { buffer = args.buf, silent = true })
	end,
})

autocmd({ "FileType" }, {
	pattern = "zig",
	callback = function(args)
		local compile = "zig build"
		local test = "zig build test --summary new"

		vim.o.makeprg = not starts_with(vim.o.makeprg, "zig build") and compile or vim.o.makeprg
		vim.opt.errorformat = { "%f:%l:%c: %t%*[^:]: %m", "%f:%l:%c: %m" }

		vim.keymap.set("n", "t", function()
			vim.o.makeprg = starts_with(vim.o.makeprg, "zig build t") and compile or test
			vim.notify("makeprg is now " .. vim.o.makeprg, vim.log.levels.INFO)
		end, { buffer = args.buf, silent = true })
	end,
})

autocmd("TextYankPost", {
	desc = "Highlight when yanking",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank({ timeout = 80 })
	end,
})
