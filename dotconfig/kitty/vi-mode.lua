local api = vim.api
local orig_buf = api.nvim_get_current_buf()

vim.o.number = false
vim.o.relativenumber = false
vim.o.buftype = "nofile"
vim.o.bufhidden = "hide"
vim.o.buflisted = false
vim.o.swapfile = false
vim.o.listchars = nil

-- disable status line:
vim.o.laststatus = 0
vim.o.statuscolumn = ""
vim.o.signcolumn = "no"

vim.bo.scrollback = 100000

local lines = vim.api.nvim_buf_get_lines(orig_buf, 0, -1, false)
while #lines > 0 and vim.trim(lines[#lines]) == "" do
	lines[#lines] = nil
end
local buf = vim.api.nvim_create_buf(false, true)
local channel = vim.api.nvim_open_term(buf, {})
vim.api.nvim_chan_send(channel, table.concat(lines, "\r\n"))
vim.api.nvim_set_current_buf(buf)

vim.bo[buf].modifiable = true

vim.cmd.norm("G")

vim.api.nvim_create_autocmd("TermEnter", { command = "qa!" })
