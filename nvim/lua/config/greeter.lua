if #vim.v.argv > 2 then
	return
end
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

local ascii = vim.split(ascii_art[3], "\n")

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
	local opts = { scope = "local" }
	local opt_values = {
		["filetype"] = "greeter",
		["buflisted"] = false,
		["bufhidden"] = "wipe",
		["buftype"] = "nofile",
		["colorcolumn"] = "",
		["relativenumber"] = false,
		["number"] = false,
		["list"] = false,
		["signcolumn"] = "no",
	}

	for o, v in pairs(opt_values) do
		vim.api.nvim_set_option_value(o, v, opts)
	end

	vim.api.nvim_set_current_buf(buf)
end

local function apply_highlights(buf, vertical_pad)
	-- Apply highlight to each line of ASCII art
	local ns = vim.api.nvim_create_namespace("my_ns")
	vim.hl.range(buf, ns, "ErrorMsg", { vertical_pad, 0 }, { vertical_pad + #ascii - 1, 0 })

	-- Highlight version line
	-- vim.api.nvim_buf_add_highlight(buf, -1, "NonText", vertical_pad + #ascii, 0, -1)

	local text_line = vertical_pad + #ascii

	vim.hl.range(buf, ns, "Conceal", { text_line, 0 }, { text_line, -1 })
end

local function calc_ascii(vertical_pad, pad_cols)
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

	return centered_ascii
end

local function greeter_draw(buf)
	set_options(buf)
	-- width
	local screen_width = vim.api.nvim_get_option_value("columns", {})
	local draw_width = count_utf_chars(ascii[1])
	local pad_width = math.floor((screen_width - draw_width) / 2)
	-- height
	local screen_height = vim.api.nvim_get_option_value("lines", {})
	local draw_height = #ascii + 1 -- Including version line
	local pad_height = math.floor((screen_height - draw_height) / 2)

	if not (screen_width >= draw_width + 2 and screen_height >= draw_height + 2) then
		-- Only display if there is enough space
		return
	end

	local centered_ascii = calc_ascii(pad_height, pad_width)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, centered_ascii)
	apply_highlights(buf, pad_height)
end

vim.cmd.enew()
local buf = vim.api.nvim_get_current_buf()
greeter_draw(buf)

local NamespaceGroup = vim.api.nvim_create_augroup("Greeter", { clear = true })
vim.api.nvim_create_autocmd("VimResized", {
	buffer = buf,
	desc = "Recalc and redraw greeter when window is resized",
	group = NamespaceGroup,
	callback = function()
		greeter_draw(buf)
	end,
})

vim.keymap.set("n", "q", ":q<cr>", {
	buffer = buf,
	noremap = true,
	silent = true,
	desc = "Quit nvim",
})
