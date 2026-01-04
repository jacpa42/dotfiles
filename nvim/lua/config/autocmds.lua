vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local ft = vim.bo[args.buf].filetype
		vim.treesitter.start(args.buf, ft)
	end,
})

-- This will check which lsp is attaching and set makeprg accordingly
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local ft = vim.bo[args.buf].filetype
		if ft == "rust" then
			vim.o.makeprg = "cargo c"
		elseif ft == "zig" then
			vim.o.makeprg = "zig build"
		else
			print("No makeprg for " .. ft .. ". Default is " .. vim.o.makeprg)
		end
	end,
})

-- Source - https://stackoverflow.com/a
-- Posted by hookenz, modified by community. See post 'Timeline' for change history
-- Retrieved 2026-01-04, License - CC BY-SA 4.0

function dump(o)
	if type(o) == "table" then
		local s = "{ "
		for k, v in pairs(o) do
			if type(k) ~= "number" then
				k = '"' .. k .. '"'
			end
			s = s .. "[" .. k .. "] = " .. dump(v) .. ","
		end
		return s .. "} "
	else
		return tostring(o)
	end
end

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

-- special commands for dapui buffers
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "dap-view", "dap-view-term", "dap-repl" }, -- dap-repl is set by `nvim-dap`
	callback = function(args)
		vim.keymap.set("n", "q", "<C-w>q", { buffer = args.buf })
	end,
})

-- Disable spell for specific file types
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "qf", "json", "noice", "man", "confini" }, -- dap-repl is set by `nvim-dap`
	callback = function()
		vim.opt_local.spell = false
		vim.opt_local.spelllang = ""
		vim.opt_local.syntax = "off"
	end,
})
