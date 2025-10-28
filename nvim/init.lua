---------------------- LAZY ----------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazypath)

local plugins = {
	{ "nvim-lua/plenary.nvim" },
	{
		"Aasim-A/scrollEOF.nvim",
		event = { "CursorMoved", "WinScrolled" },
		opts = {
			pattern = "*",
			insert_mode = true,
			floating = false,
			disabled_filetypes = { "greeter", "lazy" },
		},
	},
	{
		"mason-org/mason.nvim",
		event = "VeryLazy",
		opts = {
			ui = {
				icons = {
					package_installed = "󰦥 ", -- 
					package_pending = " ", -- 󱑢
					package_uninstalled = " ", -- 
				},
			},
		},
	},
	{
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = { user_default_options = { names = false } },
	},
	{
		"aserowy/tmux.nvim",
		keys = {
			{
				"<M-j>",
				function()
					require("tmux").move_bottom()
				end,
				{ noremap = true, silent = true },
				desc = "move down",
			},
			{
				"<M-k>",
				function()
					require("tmux").move_top()
				end,
				{ noremap = true, silent = true },
				desc = "move up",
			},
			{
				"<M-h>",
				function()
					require("tmux").move_left()
				end,
				{ noremap = true, silent = true },
				desc = "move left",
			},
			{
				"<M-l>",
				function()
					require("tmux").move_right()
				end,
				{ noremap = true, silent = true },
				desc = "move right",
			},
		},
		opts = {
			copy_sync = {
				enable = false,
				ignore_buffers = { empty = false },
				redirect_to_clipboard = false,
				register_offset = 0,
				sync_clipboard = false,
				sync_registers = false,
				sync_registers_keymap_put = false,
				sync_registers_keymap_reg = false,
				sync_deletes = false,
				sync_unnamed = false,
			},
			navigation = {
				cycle_navigation = true,
				enable_default_keybindings = false,
				persist_zoom = false,
			},
			resize = {
				enable_default_keybindings = false,
				resize_step_x = 1,
				resize_step_y = 1,
			},
			swap = {
				cycle_navigation = false,
				enable_default_keybindings = false,
			},
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		opts = {
			transparent_background = true,
			flavour = "mocha",
			show_end_of_buffer = false,
			term_colors = false,
			styles = {
				comments = { "italic" },
				conditionals = { "italic" },
				numbers = { "bold" },
				booleans = { "bold" },
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			highlight = { enable = true },
			indent = { enable = true },
			auto_install = true,
			sync_install = false,
		},
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = true,
		opts = { transparent = true },
	},
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		keys = {
			{
				"<space>e",
				desc = "File tree",
				function()
					vim.cmd("edit " .. (vim.fn.expand("%:p:h") ~= "" and vim.fn.expand("%:p:h") or "."))
				end,
			},
		},

		init = function()
			if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
				require("lazy").load({ plugins = { "oil.nvim" } })
				vim.cmd("Oil " .. vim.fn.argv(0))
			end
		end,

		opts = {
			columns = { "icon", "size" },
			delete_to_trash = false,
			skip_confirm_for_simple_edits = true,
			prompt_save_on_select_new_entry = true,
			cleanup_delay_ms = 2000,
			lsp_file_methods = {
				enabled = true,
				timeout_ms = 1000,
				autosave_changes = true,
			},
			constrain_cursor = "editable",
			watch_for_changes = true,
			keymaps = {
				["gh"] = { "actions.show_help", mode = "n" },
				["<CR>"] = "actions.select",
				["<leader>v"] = { "actions.select", opts = { vertical = true } },
				["<leader>h"] = { "actions.select", opts = { horizontal = true } },
				["<leader>p"] = "actions.preview",
				["<C-l>"] = "actions.refresh",
				["<leader>."] = { "actions.toggle_hidden", mode = "n" },
			},
			use_default_keymaps = false,
			view_options = {
				show_hidden = true,
				is_hidden_file = function(name)
					return name:match("^%.") ~= nil
				end,
				-- This function defines what will never be shown, even when `show_hidden` is set
				is_always_hidden = function()
					return false
				end,
				natural_order = "fast",
				case_insensitive = false,
				sort = {
					{ "type", "asc" },
					{ "name", "asc" },
				},
				highlight_filename = function()
					return nil
				end,
			},
		},
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			timeout = 1000,
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
				},
			},
			presets = {
				bottom_search = false,
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- add a border to hover docs and signature help
			},
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"nvim-telescope/telescope-ui-select.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		keys = {
			{
				mode = "n",
				"<space><space>",
				"<cmd>Telescope find_files hidden=true<cr>",
				desc = "find files",
			},

			{ mode = "n", "<space>fc", "<cmd>Telescope colorscheme<cr>", desc = "grep colorschemes" },
			{ mode = "n", "<space>ff", "<cmd>Telescope live_grep<cr>", desc = "grep cwd" },
			{ mode = "n", "<space>fh", "<cmd>Telescope help_tags<cr>", desc = "grep help tags into float window" },
			{ mode = "n", "<space>fk", "<cmd>Telescope keymaps<cr>", desc = "search keymaps" },
			{ mode = "n", "<space>fm", "<cmd>Telescope marks<cr>", desc = "search marks" },
			{ mode = "n", "<space>fo", "<cmd>Telescope buffers<cr>", desc = "search open buffers" },
			{ mode = "n", "<space>fr", "<cmd>Telescope oldfiles<cr>", desc = "search recent files" },
			{ mode = "n", "<space>ft", "<cmd>Telescope diagnostics<cr>", desc = "get trouble for document" },
			{ mode = "n", "<space>t", "<cmd>Telescope lsp_type_definitions<cr>", desc = "get type definition" },
			{ mode = "n", "<space>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "get type definition" },
			{ mode = "n", "gr", "<cmd>Telescope lsp_references<cr>", desc = "find symbol references" },
			{ mode = "n", "gi", "<cmd>Telescope lsp_implementations<cr>", desc = "get lsp impls" },
			{ mode = "n", "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "goto symbol definition" },
			{
				mode = "n",
				"<space>a",
				function()
					vim.lsp.buf.code_action({})
				end,
				desc = "code actions",
			},
		},

		config = function()
			require("telescope").setup({
				defaults = { file_ignore_patterns = { "^.git/" } },
				extensions = {
					["ui-select"] = require("telescope.themes").get_dropdown({}),
					["fzf"] = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
					},
				},
			})
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("ui-select")
		end,
	},
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		cmd = "ConformInfo",
		opts = {
			formatters = {
				["clang-format-custom"] = { command = "clang-format", args = { "--style=LLVM" }, stdin = true },
			},

			formatters_by_ft = {
				lua = { "stylua" },
				sh = { "shfmt" },
				zig = { "zigfmt" },
				bash = { "shfmt" },
				zsh = { "shfmt" },
				tmux = { "shfmt" },
				json = { "jq" },
				rust = { "rustfmt", lsp_format = "fallback" },
				cpp = { "clang-format", lsp_format = "fallback" },
				c = { "clang-format-custom", lsp_format = "fallback" },
			},
		},
	},
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		version = "*",
		build = "cargo build --release",
		opts_extend = {
			"sources.completion.enabled_providers",
			"sources.compat",
			"sources.default",
		},
		event = "InsertEnter",
		opts = {
			appearance = { nerd_font_variant = "normal", use_nvim_cmp_as_default = false },
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			cmdline = { enabled = false },
			completion = {
				menu = {
					draw = {
						treesitter = { "lsp" },
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind_icon", "kind" },
						},
					},
				},
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
				accept = {
					auto_brackets = {
						enabled = true,
					},
				},
			},
			keymap = {
				["<c-space>"] = { "select_and_accept" },
				["<c-j>"] = { "select_next", "fallback" },
				["<c-k>"] = { "select_prev", "fallback" },
			},
		},
	},
}

require("lazy").setup({
	spec = plugins,
	checker = { enabled = true },
})
---------------------- LAZY ----------------------
---------------------- OPTS ----------------------
vim.cmd.colorscheme("kanagawa-wave")

vim.cmd([[
	hi TelescopeBorder guibg=NONE
  hi FloatBorder guibg=NONE
  hi NormalFloat guibg=NONE
  hi FloatTitle guibg=NONE
  hi LineNr guibg=NONE
  hi DiagnosticSignInfo  guibg=NONE
  hi DiagnosticSignWarn  guibg=NONE
  hi DiagnosticSignError guibg=NONE
  hi DiagnosticSignHint  guibg=NONE
]])

vim.diagnostic.config({ virtual_text = { current_line = false } })
vim.filetype.add({ pattern = { [".*/hypr/.*%.conf"] = "hyprlang" } })

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.netrw_browsex_viewer = "qutebrowser"

vim.o.breakindent = true
vim.o.cmdheight = 0
vim.o.confirm = true
vim.o.ignorecase = true
vim.o.mouse = ""
vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 999
vim.o.shiftwidth = 2
vim.o.showmode = false
vim.o.signcolumn = "yes"
vim.o.smartcase = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.tabstop = 2
vim.o.timeoutlen = 300
vim.o.undodir = vim.fn.expand("~/.cache/undodir/")
vim.o.undofile = true
vim.o.updatetime = 250
vim.o.winborder = "rounded"
vim.o.clipboard = "unnamedplus"

vim.opt.cursorline = true
vim.opt.list = true
vim.opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }
vim.opt.termguicolors = true
---------------------- OPTS ----------------------
---------------------- REMAP ----------------------
local m = vim.keymap.set

-- Converts a decimal to hex and back again
m("n", "<c-n>", function()
	local cword = vim.fn.expand("<cword>")
	if tonumber(cword) == nil then
		return
	end

	local prefix = nil
	local fmt = nil
	if cword:sub(1, 2) == "0x" then
		prefix = "0b"
		fmt = ":b"
	elseif cword:sub(1, 2) == "0b" then
		prefix = ""
		fmt = ""
	else
		prefix = "0x"
		fmt = ":x"
	end

	-- I use python here as they have bigint by default
	local cmd = 'echo "print(f\\"' .. prefix .. "{" .. cword .. fmt .. '}\\")" | python3'
	local out = vim.fn.system(cmd)
	vim.cmd("normal! ciw" .. out)
end, { desc = "Convert (rotate) an int to hex->bin->dec->hex." })

m({ "n", "v" }, "<c-s>", function()
	local name = vim.api.nvim_buf_get_name(0)
	if name == "" then
		pcall(vim.cmd, "saveas " .. vim.fn.input("Save as: ", "", "file"))
	else
		vim.cmd("update")
	end
end, { desc = "Smart write" })

m("n", "<c-f>", "<cmd>on<cr>")
m("n", "<esc>", "<cmd>nohlsearch<cr>")
m("n", "<leader>d", "<cmd>bd<cr>", { noremap = true, silent = true })

m("n", "<tab>", "<cmd>tabn<cr>", { desc = "next tab" })
m("n", "<s-tab>", "<cmd>tabp<cr>", { desc = "previous tab" })

m("n", "<leader>h", "<cmd>split<cr>")
m("n", "<leader>l", "<cmd>Lazy<cr>")
m("n", "<leader>r", vim.lsp.buf.rename, { noremap = true, silent = true })
m("n", "<leader>v", "<cmd>vsplit<cr>")
m("n", "<leader>b", "<cmd>bnext<cr>", { desc = "next buffer" })
---------------------- REMAP ----------------------

---------------------- AUTOCMD ----------------------
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local ft = vim.bo[args.buf].filetype
		vim.treesitter.start(args.buf, ft)
	end,
})

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
---------------------- AUTOCMD ----------------------

---------------------- STATUS ----------------------
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
	return "%#StatusLine#" .. string.format(" %s", vim.bo.filetype)
end

local function lineinfo()
	local num_lines = vim.api.nvim_buf_line_count(0)
	local spacing = math.ceil(math.log10(num_lines))

	return " %3p%% %" .. spacing .. "l:%c "
end

Statusline = {
	active = function()
		return table.concat({
			"%#Statusline#",
			update_mode_colors(),
			mode(),
			"%#StatusLine#",
			filepath(),
			filename(),
			"%#StatusLine#",
			lsp(),
			macro(),
			"%=%#StatusLineExtra#",
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
---------------------- STATUS ----------------------

---------------------- LSP ----------------------
local function switch_source_header(bufnr, client)
	local method_name = "textDocument/switchSourceHeader"
	---@diagnostic disable-next-line:param-type-mismatch
	if not client or not client:supports_method(method_name) then
		return vim.notify(
			("method %s is not supported by any servers active on the current buffer"):format(method_name)
		)
	end
	local params = vim.lsp.util.make_text_document_params(bufnr)
	---@diagnostic disable-next-line:param-type-mismatch
	client:request(method_name, params, function(err, result)
		if err then
			error(tostring(err))
		end
		if not result then
			vim.notify("corresponding file cannot be determined")
			return
		end
		vim.cmd.edit(vim.uri_to_fname(result))
	end, bufnr)
end

local function symbol_info(bufnr, client)
	local method_name = "textDocument/symbolInfo"
	---@diagnostic disable-next-line:param-type-mismatch
	if not client or not client:supports_method(method_name) then
		return vim.notify("Clangd client not found", vim.log.levels.ERROR)
	end
	local win = vim.api.nvim_get_current_win()
	local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
	---@diagnostic disable-next-line:param-type-mismatch
	client:request(method_name, params, function(err, res)
		if err or #res == 0 then
			-- Clangd always returns an error, there is no reason to parse it
			return
		end
		local container = string.format("container: %s", res[1].containerName) ---@type string
		local name = string.format("name: %s", res[1].name) ---@type string
		vim.lsp.util.open_floating_preview({ name, container }, "", {
			height = 2,
			width = math.max(string.len(name), string.len(container)),
			focusable = false,
			focus = false,
			title = "Symbol Info",
		})
	end, bufnr)
end

local lsp_configs = {
	["clangd"] = {
		cmd = { "clangd" },
		root_markers = {
			".clangd",
			".clang-tidy",
			".clang-format",
			"compile_commands.json",
			"compile_flags.txt",
			"configure.ac",
			".git",
		},
		filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
		capabilities = {
			offsetEncoding = { "utf-8", "utf-16" },
			textDocument = { completion = { editsNearCursor = true } },
		},
		on_init = function(client, init_result)
			if init_result.offsetEncoding then
				client.offset_encoding = init_result.offsetEncoding
			end
		end,
		on_attach = function(client, bufnr)
			vim.api.nvim_buf_create_user_command(bufnr, "LspClangdSwitchSourceHeader", function()
				switch_source_header(bufnr, client)
			end, { desc = "Switch between source/header" })

			vim.api.nvim_buf_create_user_command(bufnr, "LspClangdShowSymbolInfo", function()
				symbol_info(bufnr, client)
			end, { desc = "Show symbol info" })
		end,
	},

	["luals"] = {
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = { globals = "vim" },
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false, -- don't prompt about love2d/etc
				},
				telemetry = { enable = false },
			},
		},
	},

	["rust_analyzer"] = {
		cmd = { "rust-analyzer" },
		filetypes = { "rust" },
		single_file_support = true,
		capabilities = {
			experimental = {
				serverStatusNotification = true,
			},
		},
		before_init = function(init_params, config)
			-- See https://github.com/rust-lang/rust-analyzer/blob/eb5da56d839ae0a9e9f50774fa3eb78eb0964550/docs/dev/lsp-extensions.md?plain=1#L26
			if config.settings and config.settings["rust-analyzer"] then
				init_params.initializationOptions = config.settings["rust-analyzer"]
			end
		end,
	},

	["hyprls"] = {
		cmd = { "hyprls" },
		filetypes = { "hyprlang" },
	},

	["zls"] = {
		cmd = { "zls" },
		filetypes = { "zig", "zir" },
		root_markers = { "zls.json", "build.zig", ".git" },
		workspace_required = false,
	},
}

for l, c in pairs(lsp_configs) do
	vim.lsp.config[l] = c
	vim.lsp.enable(l)
end
---------------------- LSP ----------------------

---------------------- GREET ----------------------
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
local vers = vim.version()

local function nvim_version()
	local startup_time_ms = require("lazy").stats().times.LazyDone
	local startup_time = string.format("%.2f", startup_time_ms)

	return "nvim v" .. vers.major .. "." .. vers.minor .. "." .. vers.patch .. " | " .. startup_time .. "ms"
end

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
	local version_line = nvim_version()
	local version_pad = math.floor((width - #version_line) / 2)
	table.insert(centered_ascii, pad_str(version_pad, version_line))

	return centered_ascii
end

local function greeter_draw(buf)
	set_options(buf)
	-- width
	local screen_width = vim.api.nvim_get_option_value("columns", {})
	local draw_width = math.max(count_utf_chars(ascii[1]), #nvim_version())
	local pad_width = math.floor((screen_width - draw_width) / 2)
	-- height
	local screen_height = vim.api.nvim_get_option_value("lines", {})
	local draw_height = #ascii + 1 -- Including version line
	local pad_height = math.floor((screen_height - draw_height) / 2)

	if not (screen_width >= draw_width + 2 and screen_height >= draw_height + 2) then
		-- Only display if there is enough space
		return
	end

	local centered_ascii = calc_ascii(screen_width, pad_height, pad_width)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, centered_ascii)
	apply_highlights(buf, pad_height)
end

vim.cmd("enew")
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
---------------------- GREET ----------------------
