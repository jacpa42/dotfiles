vim.cmd.colorscheme("catppuccin")

local width = 2
vim.opt.tabstop = width
vim.opt.shiftwidth = width
vim.opt.relativenumber = true
vim.opt.number = true
vim.o.clipboard = "unnamedplus"
vim.opt.cmdheight = 0
vim.filetype.add({ pattern = { [".*/hypr/.*%.conf"] = "hyprlang" } })
