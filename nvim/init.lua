---------------------- LAZY ----------------------
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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
			-- The pattern used for the internal autocmd to determine
			-- where to run scrollEOF. See https://neovim.io/doc/user/autocmd.html#autocmd-pattern
			pattern = "*",
			-- Whether or not scrollEOF should be enabled in insert mode
			insert_mode = true,
			-- Whether or not scrollEOF should be enabled in floating windows
			floating = true,
			-- List of filetypes to disable scrollEOF for.
			disabled_filetypes = {
				"alpha",
				"lazy",
			},
			-- List of modes to disable scrollEOF for. see https://neovim.io/doc/user/builtin.html#mode()
			disabled_modes = {},
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
		opts = {
			user_default_options = {
				names = false,
			},
		},
	},
	{
		"chentoast/marks.nvim",
		keys = {
			{ "m", mode = "n" },
			{ '"', mode = "n" },
		},
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
				-- enables copy sync. by default, all registers are synchronized.
				-- to control which registers are synced, see the `sync_*` options.
				enable = false,

				-- ignore specific tmux buffers e.g. buffer0 = true to ignore the
				-- first buffer or named_buffer_name = true to ignore a named tmux
				-- buffer with name named_buffer_name :)
				ignore_buffers = { empty = false },

				-- TMUX >= 3.2: all yanks (and deletes) will get redirected to system
				-- clipboard by tmux
				redirect_to_clipboard = false,

				-- offset controls where register sync starts
				-- e.g. offset 2 lets registers 0 and 1 untouched
				register_offset = 0,

				-- overwrites vim.g.clipboard to redirect * and + to the system
				-- clipboard using tmux. If you sync your system clipboard without tmux,
				-- disable this option!
				sync_clipboard = false,

				-- synchronizes registers *, +, unnamed, and 0 till 9 with tmux buffers.
				sync_registers = false,

				-- synchronizes registers when pressing p and P.
				sync_registers_keymap_put = false,

				-- synchronizes registers when pressing (C-r) and ".
				sync_registers_keymap_reg = false,

				-- syncs deletes with tmux clipboard as well, it is adviced to
				-- do so. Nvim does not allow syncing registers 0 and 1 without
				-- overwriting the unnamed register. Thus, ddp would not be possible.
				sync_deletes = false,

				-- syncs the unnamed register with the first buffer entry from tmux.
				sync_unnamed = false,
			},
			navigation = {
				-- cycles to opposite pane while navigating into the border
				cycle_navigation = true,

				-- enables default keybindings (C-hjkl) for normal mode
				enable_default_keybindings = false,

				-- prevents unzoom tmux when navigating beyond vim border
				persist_zoom = false,
			},
			resize = {
				-- enables default keybindings (A-hjkl) for normal mode
				enable_default_keybindings = false,

				-- sets resize steps for x axis
				resize_step_x = 1,

				-- sets resize steps for y axis
				resize_step_y = 1,
			},
			swap = {
				-- cycles to opposite pane while navigating into the border
				cycle_navigation = false,

				-- enables default keybindings (C-A-hjkl) for normal mode
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
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = { "bold" },
				booleans = { "bold" },
				properties = {},
				types = {},
				operators = {},
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
			ensure_installed = {
				"c",
				"cpp",
				"lua",
				"rust",
				"glsl",
				"python",
				"hyprlang",
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = true,
		opts = { transparent = true },
	},
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = true,
		keys = {
			{
				"<leader>e",
				function()
					local buf_path = vim.fn.expand("%:p:h")
					if buf_path ~= "" then
						vim.cmd("edit " .. buf_path)
					else
						vim.cmd("edit .")
					end
				end,
				desc = "File explorer",
			},
		},

		init = function()
			if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
				require("lazy").load({ plugins = { "oil.nvim" } })
				vim.cmd("Oil " .. vim.fn.argv(0))
			end
		end,

		opts = {
			-- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
			-- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
			default_file_explorer = true,
			-- Id is automatically added at the beginning, and name at the end
			-- See :help oil-columns
			columns = {
				"icon",
				-- "permissions",
				"size",
				-- "mtime",
			},
			-- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
			delete_to_trash = true,
			-- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
			skip_confirm_for_simple_edits = true,
			-- Selecting a new/moved/renamed file or directory will prompt you to save changes first
			-- (:help prompt_save_on_select_new_entry)
			prompt_save_on_select_new_entry = true,
			-- Oil will automatically delete hidden buffers after this delay
			-- You can set the delay to false to disable cleanup entirely
			-- Note that the cleanup process only starts when none of the oil buffers are currently displayed
			cleanup_delay_ms = 2000,
			lsp_file_methods = {
				-- Enable or disable LSP file operations
				enabled = true,
				-- Time to wait for LSP file operations to complete before skipping
				timeout_ms = 1000,
				-- Set to true to autosave buffers that are updated with LSP willRenameFiles
				-- Set to "unmodified" to only save unmodified buffers
				autosave_changes = false,
			},
			-- Constrain the cursor to the editable parts of the oil buffer
			-- Set to `false` to disable, or "name" to keep it on the file names
			constrain_cursor = "editable",
			-- Set to true to watch the filesystem for changes and reload oil
			watch_for_changes = true,
			-- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
			-- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
			-- Additionally, if it is a string that matches "actions.<name>",
			-- it will use the mapping at require("oil.actions").<name>
			-- Set to `false` to remove a keymap
			-- See :help oil-actions for a list of all available actions
			keymaps = {
				["gh"] = { "actions.show_help", mode = "n" },
				["<CR>"] = "actions.select",
				["<leader>v"] = { "actions.select", opts = { vertical = true } },
				["<leader>h"] = { "actions.select", opts = { horizontal = true } },
				["<leader>p"] = "actions.preview",
				["<C-l>"] = "actions.refresh",
				["<leader>u"] = { "actions.parent", mode = "n" },
				-- ["_"] = { "actions.open_cwd", mode = "n" },
				["_"] = false,
				["`"] = { "actions.cd", mode = "n" },
				["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
				["gs"] = { "actions.change_sort", mode = "n" },
				["gx"] = "actions.open_external",
				["g."] = { "actions.toggle_hidden", mode = "n" },
			},
			-- Set to false to disable all of the above keymaps
			use_default_keymaps = true,
			view_options = {
				-- Show files and directories that start with "."
				show_hidden = true,
				-- This function defines what is considered a "hidden" file
				is_hidden_file = function(name)
					local m = name:match("^%.")
					return m ~= nil
				end,
				-- This function defines what will never be shown, even when `show_hidden` is set
				is_always_hidden = function()
					return false
				end,
				-- Sort file names with numbers in a more intuitive order for humans.
				-- Can be "fast", true, or false. "fast" will turn it off for large directories.
				natural_order = "fast",
				-- Sort file and directory names case insensitive
				case_insensitive = false,
				sort = {
					-- sort order can be "asc" or "desc"
					-- see :help oil-columns to see which columns are sortable
					{ "type", "asc" },
					{ "name", "asc" },
				},
				-- Customize the highlight group for the file name
				highlight_filename = function()
					return nil
				end,
			},
			-- Extra arguments to pass to SCP when moving/copying files over SSH
			extra_scp_args = {},
			-- EXPERIMENTAL support for performing file operations with git
			git = {
				-- Return true to automatically git add/mv/rm files
				add = function()
					return false
				end,
				mv = function()
					return false
				end,
				rm = function()
					return false
				end,
			},
			-- Configuration for the floating window in oil.open_float
			float = {
				-- Padding around the floating window
				padding = 2,
				-- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
				max_width = 0,
				max_height = 0,
				border = "rounded",
				win_options = {
					winblend = 0,
				},
				-- optionally override the oil buffers window title with custom function: fun(winid: integer): string
				get_win_title = nil,
				-- preview_split: Split direction: "auto", "left", "right", "above", "below".
				preview_split = "auto",
				-- This is the config that will be passed to nvim_open_win.
				-- Change values here to customize the layout
				override = function(conf)
					return conf
				end,
			},
			-- Configuration for the file preview window
			preview_win = {
				-- Whether the preview window is automatically updated when the cursor is moved
				update_on_cursor_moved = true,
				-- How to open the preview window "load"|"scratch"|"fast_scratch"
				preview_method = "fast_scratch",
				-- A function that returns true to disable preview on a file e.g. to avoid lag
				disable_preview = function()
					return false
				end,
				-- Window-local options to use for preview window buffers
				win_options = {},
			},
			-- Configuration for the floating action confirmation window
			confirmation = {
				-- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
				-- min_width and max_width can be a single value or a list of mixed integer/float types.
				-- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
				max_width = 0.9,
				-- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
				min_width = { 40, 0.4 },
				-- optionally define an integer/float for the exact width of the preview window
				width = nil,
				-- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
				-- min_height and max_height can be a single value or a list of mixed integer/float types.
				-- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
				max_height = 0.9,
				-- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
				min_height = { 5, 0.1 },
				-- optionally define an integer/float for the exact height of the preview window
				height = nil,
				border = "rounded",
				win_options = {
					winblend = 0,
				},
			},
			-- Configuration for the floating progress window
			progress = {
				max_width = 0.9,
				min_width = { 40, 0.4 },
				width = nil,
				max_height = { 10, 0.9 },
				min_height = { 5, 0.1 },
				height = nil,
				border = "rounded",
				minimized_border = "none",
				win_options = {
					winblend = 0,
				},
			},
			-- Configuration for the floating SSH window
			ssh = {
				border = "rounded",
			},
			-- Configuration for the floating keymaps help window
			keymaps_help = {
				border = "rounded",
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
		"ibhagwan/fzf-lua",
		cmd = "FzfLua",
		opts = {
			fzf_bin = "sk",
			fzf_colors = true,

			winopts = {
				width = 0.9,
				height = 0.9,
				row = 0.5,
				col = 0.5,
				preview = {
					scrollchars = { "┃", "" },
					default = "bat",
					treesitter = false,
				},
			},

			zoxide = {
				actions = {
					enter = function(selected)
						local dir = selected[1]:match("\t(.*)")
						vim.cmd.cd(dir)
						return require("fzf-lua").files({ cwd = dir })
					end,
				},
			},

			helptags = {
				previewer = "help_native",
				actions = {
					enter = function(items)
						local topic = items[1]:match("^[^%s]+")

						-- Close any help buffers if they exist?
						for _, buf in ipairs(vim.api.nvim_list_bufs()) do
							if vim.bo[buf].filetype == "help" then
								vim.api.nvim_buf_delete(buf, {})
							end
						end

						local popup = require("nui.popup")({
							enter = true,
							relative = "editor",
							focusable = true,
							border = { style = "rounded" },
							position = "50%",
							size = { width = "60%", height = "80%" },
							buf_options = { buftype = "help", swapfile = false },
						})

						popup:mount()

						vim.api.nvim_buf_call(popup.bufnr, function()
							vim.cmd("help " .. topic)
						end)

						popup:map("n", "q", function()
							popup:unmount()
						end)
						popup:on("BufLeave", function()
							popup:unmount()
						end, { once = true })
					end,
				},
			},

			manpages = { previewer = "man_native" },
			lsp = { code_actions = { previewer = "codeaction_native" } },
			tags = { previewer = "bat" },
			btags = { previewer = "bat" },
		},

		config = function(_, opts)
			require("fzf-lua").setup(opts)
			require("fzf-lua").register_ui_select()
		end,
	},
	{
		"stevearc/conform.nvim",
		lazy = true,
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			notify_on_error = false,
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},

			formatters = {
				["clang-format-custom"] = {
					command = "clang-format",
					args = { "--style=LLVM" },
					stdin = true,
				},
			},

			formatters_by_ft = {
				lua = { "stylua" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				zsh = { "shfmt" },
				tmux = { "shfmt" },
				json = { "jq" },
				rust = { "rustfmt", lsp_format = "fallback" },
				cpp = { "clang-format", lsp_format = "fallback" },
				c = {
					"clang-format-custom",
					lsp_format = "fallback",
				},
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

vim.cmd("hi FloatBorder guibg=NONE<cr>")
vim.cmd("hi NormalFloat guibg=NONE<cr>")
vim.cmd("hi FloatTitle guibg=NONE<cr>")
vim.cmd("hi LineNr guibg=NONE<cr>")

vim.o.tabstop = 2
vim.o.winborder = "rounded"
vim.o.shiftwidth = 2
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
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.termguicolors = true

vim.g.netrw_browsex_viewer = "qutebrowser"
---------------------- OPTS ----------------------

---------------------- REMAP ----------------------
local m = vim.keymap.set

m("n", "<leader>fh", function()
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
end)

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
end)

m({ "n", "v" }, "<leader>s", function()
	local name = vim.api.nvim_buf_get_name(0)
	if name == "" then
		pcall(vim.cmd, "saveas " .. vim.fn.input("Save as: ", "", "file"))
	else
		vim.cmd("update")
	end
end, { desc = "Smart write" })

m("n", "<leader>v", "<cmd>vsplit<cr>")
m("n", "<leader>h", "<cmd>split<cr>")
m("n", "<leader>l", "<cmd>Lazy<cr>")
m("n", "<leader>d", "<cmd>bd<cr>", { noremap = true, silent = true })
m("n", "<Esc>", "<cmd>nohlsearch<cr>")
m("n", "<leader><leader>", "<cmd>FzfLua files<cr>", { desc = "Ripgrep cwd" })
m("n", "<leader>ff", "<cmd>FzfLua live_grep<cr>", { desc = "Ripgrep cwd" })
m("n", "<leader>fo", "<cmd>FzfLua buffers<cr>", { desc = "Search open buffers" })
m("n", "<leader>fc", "<cmd>FzfLua colorschemes<cr>", { desc = "Ripgrep colorschemes" })
m("n", "<leader>fj", "<cmd>FzfLua zoxide<cr>", { desc = "zoxide projects" })
m("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", { desc = "Search recent files" })
m("n", "<leader>fk", "<cmd>FzfLua keymaps<cr>", { desc = "Search keymaps" })
m("n", "<leader>fm", "<cmd>FzfLua marks<cr>", { desc = "Search marks" })
m("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", { desc = "Find symbol definition", noremap = true, silent = true })
m("n", "gD", "<cmd>FzfLua lsp_declarations<cr>", { desc = "Find symbol declaration", noremap = true, silent = true })
m("n", "gi", "<cmd>FzfLua lsp_implementations<cr>", { desc = "Get lsp impls" })
m("n", "<leader>fT", "<cmd>FzfLua diagnostics_workspace<cr>", { desc = "Get trouble for workspace" })
m("n", "<leader>ft", "<cmd>FzfLua diagnostics_document<cr>", { desc = "Get trouble for document" })
m("n", "<leader>r", vim.lsp.buf.rename, { noremap = true, silent = true })
m("n", "<leader>t", vim.lsp.buf.type_definition, { noremap = true, silent = true })
m("n", "<C-f>", "<cmd>on<cr>", { noremap = true, silent = true })
m({ "n", "v" }, "<leader>a", "<cmd>FzfLua lsp_code_actions<cr>")
m("n", "<leader>fh", "<cmd>FzfLua helptags<cr>", { desc = "Grep neovim help tags into float window" })

---------------------- REMAP ----------------------

---------------------- AUTOCMD ----------------------
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
	local fname = vim.fn.expand("%:t")
	if fname == "" then
		return ""
	end
	return fname .. " "
end

local function macro()
	local register = vim.fn.reg_recording()
	if register ~= "" then
		return "%#ErrorMsg#@" .. register .. "%#StatusLine#"
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
			macro(),
			lsp(),
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
vim.lsp.config["clangd"] = {
	cmd = { "clangd", "--background-index" },
	root_markers = { "compile_commands.json", "compile_flags.txt" },
	filetypes = { "c", "cpp" },
}

vim.lsp.config["luals"] = {
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
}

vim.lsp.config["rust_analyzer"] = {
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
}

vim.lsp.config["hyprls"] = {
	cmd = { "hyprls" },
	filetypes = { "hyprlang" },
}

vim.lsp.config["zls"] = {
	cmd = { "zls" },
	filetypes = { "zig", "zir" },
	root_markers = { "zls.json", "build.zig", ".git" },
	workspace_required = false,
}

vim.lsp.enable({ "clangd", "luals", "rust_analyzer", "hyprls", "zls" })
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
