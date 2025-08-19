local ascii_art = {
	[[
	████╗     ████╗ ██████████═╗   ████████████╗  █████████████╗
	████║   █████╔╝████████████║   ████████████║  █████████████║
	████║ █████╔═╝ ████╔═══████║  ████╔═════████╗█████╔═══█████║
	█████████╔═╝   ████║   ████║  ████║     ████║█████║   ╚════╝
	███████╔═╝     ████████████║  ██████████████║█████║  ██████╗
	█████████╗     ███████████╔╝  ██████████████║█████║  ██████║
	████╔═█████╗   ████╔═══████╗  ████╔═════████║█████║  ╚═████║
	████║ ╚═█████╗ ████║   ╚████╗ ████║     ████║║█████████████║
	████║   ╚═████╗████║    ╚████╗████║     ████║║████████████╔╝
	╚═══╝     ╚═══╝╚═══╝     ╚═══╝╚═══╝     ╚═══╝╚════════════╝
]],
	[[
      ___           ___           ___           ___
     /\__\         /\  \         /\  \         /\  \
    /:/  /        /::\  \       /::\  \       /::\  \
   /:/__/        /:/\:\  \     /:/\:\  \     /:/\:\  \
  /::\__\____   /::\~\:\  \   /::\~\:\  \   /:/  \:\  \
 /:/\:::::\__\ /:/\:\ \:\__\ /:/\:\ \:\__\ /:/__/_\:\__\
 \/_|:|~~|~    \/_|::\/:/  / \/__\:\/:/  / \:\  /\ \/__/
    |:|  |        |:|::/  /       \::/  /   \:\ \:\__\
    |:|  |        |:|\/__/        /:/  /     \:\/:/  /
    |:|  |        |:|  |         /:/  /       \::/  /
     \|__|         \|__|         \/__/         \/__/
]],
	[[
 ██ ▄█▀ ██▀███   ▄▄▄        ▄████
 ██▄█▒ ▓██ ▒ ██▒▒████▄     ██▒ ▀█▒
▓███▄░ ▓██ ░▄█ ▒▒██  ▀█▄  ▒██░▄▄▄░
▓██ █▄ ▒██▀▀█▄  ░██▄▄▄▄██ ░▓█  ██▓
▒██▒ █▄░██▓ ▒██▒ ▓█   ▓██▒░▒▓███▀▒
▒ ▒▒ ▓▒░ ▒▓ ░▒▓░ ▒▒   ▓▒█░ ░▒   ▒
░ ░▒ ▒░  ░▒ ░ ▒░  ▒   ▒▒ ░  ░   ░
░ ░░ ░   ░░   ░   ░   ▒   ░ ░   ░
░  ░      ░           ░  ░      ░
]],
}

-- Module
local M = {}

local ascii = vim.split(ascii_art[3], "\n")
local vers = vim.version()

local startup_time_ms = require("lazy").stats().times.LazyDone
local startup_time = string.format("%.2f", startup_time_ms)

local nvim_version = "nvim v" .. vers.major .. "." .. vers.minor .. "." .. vers.patch .. " | " .. startup_time .. "ms"

local function pad_str(padding, string)
	return string.rep(" ", padding) .. string
end

local function count_utf_chars(str)
	local count = 0
	local i = 1
	local len = #str
	while i <= len do
		local byte = str:byte(i)
		if byte < 128 then
			i = i + 1 -- ASCII byte
		elseif byte < 224 then
			i = i + 2 -- 2 byte character
		elseif byte < 240 then
			i = i + 3 -- 3 byte character
		else
			i = i + 4 -- 4 byte character
		end
		count = count + 1
	end
	return count
end

local function set_options(buf)
	vim.api.nvim_buf_set_option(buf, "filetype", "greeter")
	vim.api.nvim_buf_set_option(buf, "modified", false)
	vim.api.nvim_buf_set_option(buf, "buflisted", false)
	vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
	vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
	vim.api.nvim_buf_set_option(buf, "colorcolumn", "")
	vim.api.nvim_buf_set_option(buf, "relativenumber", false)
	vim.api.nvim_buf_set_option(buf, "number", false)
	vim.api.nvim_buf_set_option(buf, "list", false)
	vim.api.nvim_buf_set_option(buf, "signcolumn", "no")
	vim.api.nvim_set_current_buf(buf)
end

local function apply_highlights(buf, vertical_pad)
	-- Apply highlight to each line of ASCII art
	for i = vertical_pad + 1, vertical_pad + #ascii do
		vim.api.nvim_buf_add_highlight(buf, -1, "ErrorMsg", i - 1, 0, -1)
	end

	-- Highlight version line
	vim.api.nvim_buf_add_highlight(buf, -1, "NonText", vertical_pad + #ascii, 0, -1)
end

local function calc_ascii(width, vertical_pad, pad_cols)
	local centered_ascii = {}

	-- Add empty lines for vertical padding
	for _ = 1, vertical_pad do
		table.insert(centered_ascii, "")
	end

	-- Add ASCII lines with padding
	for _, line in ipairs(ascii) do
		local padded_line = pad_str(pad_cols, line)
		table.insert(centered_ascii, padded_line)
	end

	-- Add version line centered
	local version_line = nvim_version
	local version_pad = math.floor((width - #version_line) / 2)
	table.insert(centered_ascii, pad_str(version_pad, version_line))

	return centered_ascii
end

function M.draw(buf)
	set_options(buf)
	-- width
	local screen_width = vim.api.nvim_get_option("columns")
	local draw_width = math.max(count_utf_chars(ascii[1]), #nvim_version)
	local pad_width = math.floor((screen_width - draw_width) / 2)
	-- height
	local screen_height = vim.api.nvim_get_option("lines")
	local draw_height = #ascii + 1 -- Including version line
	local pad_height = math.floor((screen_height - draw_height) / 2)

	if not (screen_width >= draw_width + 2 and screen_height >= draw_height + 2) then
		-- Only display if there is enough space
		return
	end

	local centered_ascii = calc_ascii(screen_width, pad_height, pad_width)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, centered_ascii)
	apply_highlights(buf, pad_height)

	vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

function M.create_new_buffer_for_insert(greeter_buf)
	-- Create a new buffer that is empty and listed
	local new_buf = vim.api.nvim_create_buf(true, false)

	-- Set the new buffer in the current window
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(win, new_buf)

	-- -- Start insert mode in the new buffer
	-- vim.api.nvim_command("startinsert")

	if vim.api.nvim_buf_is_valid(greeter_buf) then
		-- Delete the greeter buffer if it's no longer needed
		vim.api.nvim_buf_delete(greeter_buf, { force = true })
	end
end

function M.display()
	vim.cmd("enew")
	local buf = vim.api.nvim_get_current_buf()
	M.draw(buf)

	local NamespaceGroup = vim.api.nvim_create_augroup("Greeter", { clear = true })
	vim.api.nvim_create_autocmd("VimResized", {
		buffer = buf,
		desc = "Recalc and redraw greeter when window is resized",
		group = NamespaceGroup,
		callback = function()
			M.draw(buf)
		end,
	})

	vim.keymap.set("n", "q", ":q<cr>", {
		buffer = buf,
		noremap = true,
		silent = true,
		desc = "Quit nvim",
	})
end

function M.display_conditionally()
	-- Check if there were args (i.e. opened file), non-empty buffer, or started in insert mode
	if vim.fn.argc() == 0 or vim.fn.line2byte("$") ~= -1 and not vim.opt.insertmode then
		M.display()
	end
end

M.display_conditionally()

return M
