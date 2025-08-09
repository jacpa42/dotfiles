vim.cmd.colorscheme("kanagawa-wave")

vim.cmd("hi FloatBorder guibg=NONE<cr>")
vim.cmd("hi NormalFloat guibg=NONE<cr>")
vim.cmd("hi FloatTitle guibg=NONE<cr>")
vim.cmd("hi LineNr guibg=NONE<cr>")

local width = 2
vim.o.tabstop = width
vim.o.winborder = "rounded"
vim.o.shiftwidth = width
vim.o.number = true
vim.o.relativenumber = true
vim.o.undodir = vim.fn.expand("~/.cache/undodir/")
vim.o.undofile = true
vim.o.swapfile = false

vim.o.mouse = ""
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitbelow = true
vim.o.splitright = true

vim.opt.list = true
vim.opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }

vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

vim.o.breakindent = true
vim.opt.cursorline = true
vim.o.scrolloff = 999
vim.o.confirm = true

vim.o.showmode = false
vim.o.cmdheight = 0
vim.filetype.add({ pattern = { [".*/hypr/.*%.conf"] = "hyprlang" } })
vim.filetype.add({ pattern = { [".*/hypr/.*%.conf"] = "hyprlang" } })

vim.diagnostic.config({
	virtual_text = { current_line = false },
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

vim.g.netrw_browsex_viewer = "qutebrowser"
