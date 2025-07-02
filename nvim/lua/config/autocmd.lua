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

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "help", "man", "checkhealth", "lspinfo" },
	callback = function(args)
		local buf = args.buf
		-- opens vertically
		-- vertical help!!
		vim.cmd("wincmd L")
		vim.keymap.set("n", "q", ":q<cr>", {
			buffer = buf,
			noremap = true,
			silent = true,
			desc = "Exit buffer",
		})
	end,
})
