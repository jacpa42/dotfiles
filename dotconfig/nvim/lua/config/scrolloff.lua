local M = {}

M.opts = {
	pattern = "*",
	insert_mode = false,
	floating = true,
	disabled_filetypes = { "terminal" },
	disabled_modes = { "t", "nt" },
}

local mode_disabled = false

local function is_disabled()
	return mode_disabled or M.opts.disabled_filetypes[vim.o.filetype] == true
end

local function check_eof_scrolloff(ev)
	if is_disabled() then
		return
	end

	if M.opts.floating == false then
		local curr_win = vim.api.nvim_win_get_config(0)
		if curr_win.relative ~= "" then
			return
		end
	end

	if ev.event == "WinScrolled" then
		local win_id = vim.api.nvim_get_current_win()
		local win_event = vim.v.event[tostring(win_id)]
		if win_event ~= nil and win_event.topline <= 0 then
			return
		end
	end

	local win_height = vim.fn.winheight(0)
	local win_cur_line = vim.fn.winline()
	local visual_distance_to_eof = win_height - win_cur_line

	if visual_distance_to_eof < vim.o.scrolloff then
		local win_view = vim.fn.winsaveview()
		vim.fn.winrestview({
			skipcol = 0, -- Without this, `gg` `G` can cause the cursor position to be shown incorrectly
			topline = win_view.topline + vim.o.scrolloff - visual_distance_to_eof,
		})
	end
end

local vim_resized_cb = function()
	if is_disabled() then
		return
	end

	vim.o.scrolloff = math.floor(vim.fn.winheight(0) / 2)
end

----------------------------------------------------------------------------
-------------------------------- setup code --------------------------------
----------------------------------------------------------------------------

local function setup()
	local disabled_filetypes_hashmap = {}
	for _, val in pairs(M.opts.disabled_filetypes) do
		disabled_filetypes_hashmap[val] = true
	end
	M.opts.disabled_filetypes = disabled_filetypes_hashmap

	local disabled_modes_hashmap = {}
	for _, val in pairs(M.opts.disabled_modes) do
		disabled_modes_hashmap[val] = true
	end
	M.opts.disabled_modes = disabled_modes_hashmap

	local autocmds = { "CursorMoved", "WinScrolled" }
	if M.opts.insert_mode then
		table.insert(autocmds, "CursorMovedI")
	end

	local scrollEOF_group = vim.api.nvim_create_augroup("ScrollEOF", { clear = true })

	vim.api.nvim_create_autocmd("ModeChanged", {
		group = scrollEOF_group,
		pattern = M.opts.pattern,
		callback = function()
			mode_disabled = M.opts.disabled_modes[vim.api.nvim_get_mode().mode] == true
		end,
	})

	vim.api.nvim_create_autocmd({ "VimResized" }, {
		group = scrollEOF_group,
		pattern = M.opts.pattern,
		callback = vim_resized_cb,
	})

	vim.api.nvim_create_autocmd(autocmds, {
		group = scrollEOF_group,
		pattern = M.opts.pattern,
		callback = check_eof_scrolloff,
	})

	vim_resized_cb()
	vim.defer_fn(vim_resized_cb, 0)
end

setup()
