local function mode()
	local modes = {
		["n"] = "NORMAL",
		["no"] = "NORMAL",
		["v"] = "VISUAL",
		["V"] = "VISUAL LINE",
		[""] = "VISUAL BLOCK",
		["s"] = "SELECT",
		["S"] = "SELECT LINE",
		[""] = "SELECT BLOCK",
		["i"] = "INSERT",
		["ic"] = "INSERT",
		["R"] = "REPLACE",
		["Rv"] = "VISUAL REPLACE",
		["c"] = "COMMAND",
		["cv"] = "VIM EX",
		["ce"] = "EX",
		["r"] = "PROMPT",
		["rm"] = "MOAR",
		["r?"] = "CONFIRM",
		["!"] = "SHELL",
		["t"] = "TERMINAL",
		["nt"] = "NORMTERM",
	}

	local current_mode = vim.api.nvim_get_mode().mode
	return string.format(" %s ", modes[current_mode])
end

local function update_mode_colors()
	local current_mode = vim.api.nvim_get_mode().mode
	local mode_color = "%#MiniStatuslineModeOther#"
	if current_mode == "n" then
		mode_color = "%#MiniStatuslineModeNormal#"
	elseif current_mode == "i" or current_mode == "ic" then
		mode_color = "%#MiniStatuslineModeInsert#"
	elseif current_mode == "v" or current_mode == "V" or current_mode == "" then
		mode_color = "%#MiniStatuslineModeVisual#"
	elseif current_mode == "R" then
		mode_color = "%#MiniStatuslineModeReplace#"
	elseif current_mode == "c" then
		mode_color = "%#MiniStatuslineModeCommand#"
	end
	return mode_color
end

local function filepath()
	local fpath = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.:h")
	if fpath == "" or fpath == "." then
		return " "
	end

	return string.format(" %%<%s/", fpath)
end

local function filename()
	local fname = vim.fn.expand("%:t") .. (vim.bo.modified and " [+]" or "    ")
	if fname == "" then
		return ""
	end
	return fname .. " "
end

local function macro()
	local register = vim.fn.reg_recording()
	if register ~= "" then
		return " %#ErrorMsg#@" .. register .. "%#StatusLine#"
	else
		return "  "
	end
end

local function lsp()
	local count = {}

	local levels = {
		errors = vim.diagnostic.severity.ERROR,
		warnings = vim.diagnostic.severity.WARN,
		info = vim.diagnostic.severity.INFO,
		hints = vim.diagnostic.severity.HINT,
	}

	for k, level in pairs(levels) do
		count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
	end

	local errors = ""
	local warnings = ""
	local hints = ""
	local info = ""

	if count["errors"] ~= 0 then
		errors = " %#DiagnosticError# " .. count["errors"]
	end
	if count["warnings"] ~= 0 then
		warnings = " %#DiagnosticWarn# " .. count["warnings"]
	end
	if count["hints"] ~= 0 then
		hints = " %#DiagnosticHint#󰦥 " .. count["hints"]
	end
	if count["info"] ~= 0 then
		info = " %#DiagnosticInformation# " .. count["info"]
	end

	return errors .. warnings .. hints .. info .. "%#StatusLine#"
end

local function filetype()
	return string.format(" %s", vim.bo.filetype)
end

local function lineinfo()
	local num_lines = vim.api.nvim_buf_line_count(0)
	local spacing = math.floor(math.log10(num_lines)) + 1

	return " %3p%% %" .. spacing .. "l"
end

Statusline = {
	active = function()
		return table.concat({
			update_mode_colors(),
			mode(),
			"%#StatusLine#",
			filepath(),
			filename(),
			"%#StatusLine#",
			lsp(),
			macro(),
			"%=%#StatusLine#",
			filetype(),
			lineinfo(),
		})
	end,

	inactive = function()
		return " %F"
	end,
}

vim.api.nvim_exec2(
	[[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
  augroup END
]],
	{ output = false }
)
