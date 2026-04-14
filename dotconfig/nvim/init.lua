-- epic experimental ui
require("vim._core.ui2").enable({ msg = { targets = "msg", msg = { timeout = 3000 } } })

----------------------------------opts----------------------------------
----------------------------------opts----------------------------------
----------------------------------opts----------------------------------

vim.filetype.add({ pattern = { [".*/hypr/.*%.conf"] = "hyprlang" } })
vim.o.background = "dark"
vim.o.spell = true
vim.o.spelllang = "en_gb"
vim.o.shortmess = "aoOstTAIcCq"
vim.o.grepprg = "rg --vimgrep --no-hidden --no-heading"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.netrw_browsex_viewer = "qutebrowser"
vim.o.breakindent = true
vim.o.wrap = true
vim.o.confirm = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.mouse = ""
vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 999
vim.o.sidescrolloff = 5
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.showmode = false
vim.o.signcolumn = "number"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.timeoutlen = 500
vim.o.undodir = vim.fn.expand("~/.cache/undodir/")
vim.o.undofile = true
vim.o.updatetime = 250
vim.o.winborder = "rounded"
vim.o.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.list = true
vim.opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }
vim.opt.termguicolors = true
vim.o.textwidth = 80
vim.o.formatoptions = "cro"
vim.o.cmdheight = 0

----------------------------------statusline----------------------------------
----------------------------------statusline----------------------------------
----------------------------------statusline----------------------------------

function Macro()
	local macroaddr = vim.fn.reg_recording()
	if macroaddr ~= "" then
		return "%#Macro#@" .. macroaddr .. "%*"
	else
		return ""
	end
end
vim.o.statusline =
	"%<%f %h%w%m%r %{% luaeval('Macro()') %}%=%{% luaeval('(package.loaded[''vim.ui''] and vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin or -1) and vim.ui.progress_status()) or '''' ')%}%{% &showcmdloc == 'statusline' ? '%-10.S ' : '' %}%{% exists('b:keymap_name') ? '<'..b:keymap_name..'> ' : '' %}%{% &busy > 0 ? '◐ ' : '' %}%{% luaeval('(package.loaded[''vim.diagnostic''] and next(vim.diagnostic.count()) and vim.diagnostic.status() .. '' '') or '''' ') %}%{% &ruler ? ( &rulerformat == '' ? '%-14.(%l,%c%V%) %P' : &rulerformat ) : '' %}"

----------------------------------autocmd----------------------------------
----------------------------------autocmd----------------------------------
----------------------------------autocmd----------------------------------

local autocmd = vim.api.nvim_create_autocmd

local function starts_with(str, prefix)
	return string.sub(str, 1, string.len(prefix)) == prefix
end

local function buf_disable_spell()
	vim.o.spell = false
	vim.o.spelllang = ""
end

local function buf_enable_spell()
	vim.o.spell = true
	vim.o.spelllang = "en_gb"
end

function BufToggleSpell()
	require("config.opts")
	if vim.o.spell then
		buf_disable_spell()
	else
		buf_enable_spell()
	end
end

-- special commands for dapui buffers
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})

-- special commands for dapui buffers
autocmd({ "FileType" }, {
	pattern = { "dap-view", "dap-view-term", "dap-repl" }, -- dap-repl is set by `nvim-dap`
	callback = function(args)
		vim.keymap.set("n", "q", "<C-w>q", { buffer = args.buf })
	end,
})

-- Disable spell for specific file types
autocmd({ "FileType" }, {
	pattern = { "qf", "json", "man", "confini", "hyprlang", "sshconfig", "sh", "openvpn", "zathurarc" },
	callback = buf_disable_spell,
})

-- Disable spell for terminal
autocmd({ "TermOpen" }, {
	callback = buf_disable_spell,
})

autocmd({ "FileType" }, {
	pattern = "rust",
	callback = function(args)
		local compile = "cargo c --tests --all-features"
		local test = 'cargo nextest run --all-features --max-fail="10:immediate"'

		vim.o.makeprg = compile
		vim.opt_local.errorformat = {
			"%.%# panicked at %f:%l:%c:", -- cargo test
			"%.%# --> %f:%l:%c", -- cargo check/build
			"%.%# --> %f:%l:%c", -- cargo test debug prints
			"%.%# [%f:%l:%c] %.%#", -- cargo test debug prints
		}

		vim.keymap.set("n", "t", function()
			vim.o.makeprg = starts_with(vim.o.makeprg, "cargo c") and test or compile
			vim.notify("makeprg is now " .. vim.o.makeprg, vim.log.levels.INFO)
		end, { buffer = args.buf, silent = true })
	end,
})

autocmd({ "FileType" }, {
	pattern = "zig",
	callback = function(args)
		local compile = "zig build -freference-trace=20"
		local test = "zig build test -freference-trace=20 --summary new"

		vim.o.makeprg = compile
		vim.opt.errorformat = {
			"%f:%l:%c: %t%*[^:]: %m",
			"%f:%l:%c: %m",
			"     %m: %f:%l:%c",
		}

		vim.keymap.set("n", "t", function()
			vim.o.makeprg = starts_with(vim.o.makeprg, "zig build t") and compile or test
			vim.notify("makeprg is now " .. vim.o.makeprg, vim.log.levels.INFO)
		end, { buffer = args.buf, silent = true })
	end,
})

vim.cmd("autocmd TextYankPost * silent! lua vim.hl.on_yank {higroup='Visual', timeout=100}")

----------------------------------lsp----------------------------------
----------------------------------lsp----------------------------------
----------------------------------lsp----------------------------------

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

----------------------------------scroll eof----------------------------------
----------------------------------scroll eof----------------------------------
----------------------------------scroll eof----------------------------------

if false then
	local function check_eof_scrolloff(ev)
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
		vim.o.scrolloff = math.floor(vim.fn.winheight(0) / 2)
	end

	local scrollEOF_group = vim.api.nvim_create_augroup("ScrollEOF", { clear = true })

	vim.api.nvim_create_autocmd({ "VimResized" }, {
		group = scrollEOF_group,
		callback = vim_resized_cb,
	})

	vim.api.nvim_create_autocmd({ "CursorMoved", "WinScrolled", "CursorMovedI" }, {
		group = scrollEOF_group,
		callback = check_eof_scrolloff,
	})

	vim_resized_cb()
	vim.defer_fn(vim_resized_cb, 0)
end
----------------------------------keymap----------------------------------
----------------------------------keymap----------------------------------
----------------------------------keymap----------------------------------

local map = vim.keymap.set

-- terminal stuff
map("n", "<m-v>", "<cmd>vert terminal<cr>i", { noremap = true, silent = true, desc = "vert terminal" })
map("n", "<m-v>", "<cmd>vert terminal<cr>i", { noremap = true, silent = true, desc = "vert terminal" })
map("t", "<m-v>", "<c-\\><c-n><cmd>vert terminal<cr>i", { noremap = true, silent = true, desc = "vert terminal" })
map("n", "<m-c>", "<cmd>tabnew +terminal<cr>i", { desc = "new terminal tab" })
map("t", "<m-c>", "<c-\\><c-n><cmd>tabnew +terminal<cr>i", { noremap = true, silent = true, desc = "new terminal tab" })
map("t", "<m-esc>", "<c-\\><c-n>", { noremap = true, silent = true, desc = "escape out of terminal mode" })
map("n", "<m-y>", "<cmd>tabnew +terminal\\ yazi<cr>i", { noremap = true, silent = true, desc = "yazi" })

map("n", "gr", vim.lsp.buf.references, { desc = "find symbol references" })
map("n", "gd", vim.lsp.buf.definition, { desc = "find symbol definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "find symbol decl" })

map("n", "<leader>m", "<cmd>silent make <bar> copen<cr>", { desc = "make project", noremap = true })
map("n", "M", function()
	local makecmd = vim.fn.input("edit makeprg=", vim.o.makeprg, "file")
	if makecmd:len() > 0 then
		vim.notify('makecmd = "' .. makecmd .. '"')
		vim.o.makeprg = makecmd
	end
end, { desc = "set make cmd for project", noremap = true })

map(
	"n",
	"<leader>td",
	"<cmd>silent grep '(BUG\\|FAILED\\|FIX\\|FIXME\\|HACK\\|NOTE\\|TODO\\|WARN\\|XXX\\|IMPORTANT):' | copen<cr>",
	{ desc = "grep 'TODO:'s", silent = true, noremap = true }
)

vim.api.nvim_create_user_command("CycleIntRepr", function()
	local cword = vim.fn.expand("<cword>")
	if tonumber(cword) == nil then
		return
	end

	local prefix = nil
	local fmt = nil
	if cword:sub(1, 2) == "0x" then
		prefix = "0b"
		fmt = "<cmd>b"
	elseif cword:sub(1, 2) == "0b" then
		prefix = ""
		fmt = ""
	else
		prefix = "0x"
		fmt = "<cmd>x"
	end

	-- I use python here as they have bigint by default
	local cmd = 'echo "print(f\\"' .. prefix .. "{" .. cword .. fmt .. '}\\")" | python3'
	local out = vim.fn.system(cmd)
	vim.cmd("normal! ciw" .. out)
end, { desc = "Convert (rotate) an int to hex->bin->dec->hex." })

map({ "n", "v" }, "<leader>s", function()
	local name = vim.api.nvim_buf_get_name(0)
	if name == "" then
		pcall(function()
			vim.cmd("saveas " .. vim.fn.input("Save as: ", "", "file"))
		end)
	else
		vim.cmd("silent update")
	end
end, { desc = "Smart write" })

map("n", "<c-f>", "<cmd>on<cr>", { noremap = true, silent = true })
map("n", "<esc>", "<cmd>nohl<cr>", { noremap = true, silent = true })
map("n", "<leader>d", function()
	local num_windows = vim.fn.winnr("$")
	vim.cmd(num_windows > 1 and "q" or "bd")
end, { noremap = true, silent = true })

map("n", "<leader>h", "<cmd>split<cr>")
map("n", "<leader>v", "<cmd>vsplit<cr>")
map("n", "<leader>l", vim.pack.update)
map("n", "<leader>r", vim.lsp.buf.rename, { noremap = true, silent = true })

map("n", "<c-n>", "<cmd>silent cnext<cr>", { noremap = true, silent = true })
map("n", "<c-p>", "<cmd>silent cprev<cr>", { noremap = true, silent = true })

map("n", ";", "q:", { desc = "command history" })

-- window moving stuff
map("n", "<m-j>", "<c-w>j", { noremap = true, silent = true, desc = "window focus down" })
map("n", "<m-k>", "<c-w>k", { noremap = true, silent = true, desc = "window focus up" })
map("n", "<m-h>", "<c-w>h", { noremap = true, silent = true, desc = "window focus left" })
map("n", "<m-l>", "<c-w>l", { noremap = true, silent = true, desc = "window focus right" })
map("n", "<m-J>", "<c-w>J", { noremap = true, silent = true, desc = "window focus down" })
map("n", "<m-K>", "<c-w>K", { noremap = true, silent = true, desc = "window focus up" })
map("n", "<m-H>", "<c-w>H", { noremap = true, silent = true, desc = "window focus left" })
map("n", "<m-L>", "<c-w>L", { noremap = true, silent = true, desc = "window focus right" })

map("t", "<m-j>", "<c-\\><c-n><c-w>j", { noremap = true, silent = true, desc = "window focus down" })
map("t", "<m-k>", "<c-\\><c-n><c-w>k", { noremap = true, silent = true, desc = "window focus up" })
map("t", "<m-h>", "<c-\\><c-n><c-w>h", { noremap = true, silent = true, desc = "window focus left" })
map("t", "<m-l>", "<c-\\><c-n><c-w>l", { noremap = true, silent = true, desc = "window focus right" })
map("t", "<m-J>", "<c-\\><c-n><c-w>J", { noremap = true, silent = true, desc = "window focus down" })
map("t", "<m-K>", "<c-\\><c-n><c-w>K", { noremap = true, silent = true, desc = "window focus up" })
map("t", "<m-H>", "<c-\\><c-n><c-w>H", { noremap = true, silent = true, desc = "window focus left" })
map("t", "<m-L>", "<c-\\><c-n><c-w>L", { noremap = true, silent = true, desc = "window focus right" })

map("i", "<m-j>", "<c-\\><c-n><c-w>j", { noremap = true, silent = true, desc = "window focus down" })
map("i", "<m-k>", "<c-\\><c-n><c-w>k", { noremap = true, silent = true, desc = "window focus up" })
map("i", "<m-h>", "<c-\\><c-n><c-w>h", { noremap = true, silent = true, desc = "window focus left" })
map("i", "<m-l>", "<c-\\><c-n><c-w>l", { noremap = true, silent = true, desc = "window focus right" })
map("i", "<m-J>", "<c-\\><c-n><c-w>J", { noremap = true, silent = true, desc = "window focus down" })
map("i", "<m-K>", "<c-\\><c-n><c-w>K", { noremap = true, silent = true, desc = "window focus up" })
map("i", "<m-H>", "<c-\\><c-n><c-w>H", { noremap = true, silent = true, desc = "window focus left" })
map("i", "<m-L>", "<c-\\><c-n><c-w>L", { noremap = true, silent = true, desc = "window focus right" })

map("t", "<m-r>", "<c-\\><c-n><cmd>tabn<cr>", { noremap = true, silent = true, desc = "next tab" })
map("t", "<m-e>", "<c-\\><c-n><cmd>tabp<cr>", { noremap = true, silent = true, desc = "previous tab" })
map("n", "<m-r>", "<cmd>tabn<cr>", { noremap = true, silent = true, desc = "next tab" })
map("n", "<m-e>", "<cmd>tabp<cr>", { noremap = true, silent = true, desc = "previous tab" })

-- grep selection
map(
	"v",
	"<leader>f",
	"\"zy<cmd>exec 'silent grep ' . shellescape(@z) . ' | copen | wincmd p'<cr>",
	{ desc = "grep current visual selection" }
)

-- telescope stuff
map("n", "<leader><leader>", "<cmd>Telescope find_files hidden=true<cr>", { desc = "find files" })
map("n", "<leader>tt", "<cmd>Telescope<cr>", { desc = "search telescope commands" })
map("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "search nvim commands" })
map("n", "<leader>ff", "<cmd>Telescope live_grep<cr>", { desc = "search cwd" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "search help tags into float window" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "search keymaps" })
map("n", "<leader>fm", "<cmd>Telescope man_pages<cr>", { desc = "search marks" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "search open buffers" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "search recent files" })
map("n", "<leader>ft", "<cmd>Telescope diagnostics<cr>", { desc = "get trouble for document" })
map("n", "<leader>t", "<cmd>Telescope lsp_type_definitions<cr>", { desc = "get type definition" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "get type definition" })
map("n", "gi", "<cmd>Telescope lsp_implementations<cr>", { desc = "get methods for type" })
map("n", "z=", "<cmd>Telescope spell_suggest<cr>", { desc = "spell suggest" })
map({ "n", "v" }, "<leader>a", function()
	vim.lsp.buf.code_action({})
end, { desc = "code actions" })

map("n", "<space>e", function()
	vim.cmd("edit " .. (vim.fn.expand("%:p:h") ~= "" and vim.fn.expand("%:p:h") or "."))
end, { desc = "File tree" })

-- nvim DAP stuff
map("n", "<leader>b", "<cmd>DapToggleBreakpoint<cr>", { desc = "toggle breakpoint" })
map("n", "<c-right>", "<cmd>DapContinue<cr>", { desc = "continue until next breakpoint" })
map("n", "<right>", "<cmd>DapStepInto<cr>", { desc = "dap step into" })
map("n", "<down>", "<cmd>DapStepOver<cr>", { desc = "dap step over" })
map("n", "<up>", "<cmd>DapStepOut<cr>", { desc = "dap step out" })

----------------------------------plugins----------------------------------
----------------------------------plugins----------------------------------
----------------------------------plugins----------------------------------
vim.pack.add({
	"https://github.com/rafamadriz/friendly-snippets", -- dependency
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-lua/plenary.nvim", -- dependency
	"https://github.com/nvim-tree/nvim-web-devicons", -- dependency
	"https://github.com/nvim-telescope/telescope-ui-select.nvim", -- dependency
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons", -- dependency
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/igorlfs/nvim-dap-view", -- dependency
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/brenoprata10/nvim-highlight-colors",
})

local PluginLoaderGroup = vim.api.nvim_create_augroup("Pack", { clear = true })

-- init oil straight away
require("oil").setup({
	columns = { "icon", "size" },
	delete_to_trash = true,
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
		sort = { { "type", "asc" }, { "name", "asc" } },
		highlight_filename = function()
			return nil
		end,
	},
})

-- treesitter
autocmd("BufAdd", {
	desc = "treesitter start",
	group = PluginLoaderGroup,
	once = true,
	callback = function()
		require("nvim-treesitter").setup({
			highlight = {
				enable = true,
				disable = function()
					local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(0))
					if ok and stats and stats.size > 100 * 1024 then
						vim.notify("disabling treesitter")
						return true
					end
				end,
			},
			indent = { enable = true },
			auto_install = true,
			sync_install = true,
		})
	end,
})

autocmd("BufAdd", {
	desc = "telescope setup",
	group = PluginLoaderGroup,
	once = true,
	callback = function()
		require("telescope").setup({
			defaults = { file_ignore_patterns = { "^.git/" } },
			extensions = {
				["ui-select"] = require("telescope.themes").get_dropdown({}),
			},
		})
		require("telescope").load_extension("ui-select")
	end,
})

autocmd("InsertEnter", {
	desc = "blink setup",
	group = PluginLoaderGroup,
	once = true,
	callback = function()
		require("blink.cmp").setup({
			appearance = { nerd_font_variant = "mono", use_nvim_cmp_as_default = false },
			sources = { default = { "lsp", "path", "snippets", "buffer", "cmdline" } },
			fuzzy = { implementation = "prefer_rust_with_warning" },
			completion = {
				menu = {
					draw = {
						treesitter = { "lsp" },
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind_icon", "kind" },
						},
						components = {
							-- customize the drawing of kind icons
							kind_icon = {
								text = function(ctx)
									-- default kind icon
									local icon = ctx.kind_icon
									-- if LSP source, check for color derived from documentation
									if ctx.item.source_name == "LSP" then
										local color_item = require("nvim-highlight-colors").format(
											ctx.item.documentation,
											{ kind = ctx.kind }
										)
										if color_item and color_item.abbr ~= "" then
											icon = color_item.abbr
										end
									end
									return icon .. ctx.icon_gap
								end,
								highlight = function(ctx)
									-- default highlight group
									local highlight = "BlinkCmpKind" .. ctx.kind
									-- if LSP source, check for color derived from documentation
									if ctx.item.source_name == "LSP" then
										local color_item = require("nvim-highlight-colors").format(
											ctx.item.documentation,
											{ kind = ctx.kind }
										)
										if color_item and color_item.abbr_hl_group then
											highlight = color_item.abbr_hl_group
										end
									end
									return highlight
								end,
							},
						},
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500,
				},
				accept = { auto_brackets = { enabled = true } },
			},
			keymap = {
				["<c-space>"] = { "select_and_accept" },
				["<c-j>"] = { "select_next", "fallback" },
				["<c-k>"] = { "select_prev", "fallback" },
			},
		})
	end,
})

autocmd("FileType", {
	desc = "dap setup",
	pattern = { "zig" },
	group = PluginLoaderGroup,
	once = true,
	callback = function()
		local dapview = require("dap-view")
		dapview.setup()
		local dap = require("dap")
		dap.listeners.before.attach.dapui_config = function()
			dapview.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapview.open()
		end
		dap.adapters.lldb = {
			type = "executable",
			command = "/usr/bin/codelldb",
			name = "lldb",
		}
		-- setup a debugger config for zig projects
		dap.configurations.zig = {
			{
				name = "Launch",
				type = "lldb",
				request = "launch",
				program = function()
					local result = vim.fn.system({
						"fd",
						"-HI1agtx",
						vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
						vim.fn.getcwd(),
					})

					return result[1] or vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				args = {},
			},
		}
	end,
})

autocmd("BufAdd", {
	desc = "conform setup",
	group = PluginLoaderGroup,
	once = true,
	callback = function()
		require("conform").setup({
			formatters = {
				["clang-format-custom"] = {
					command = "clang-format",
					args = { "--style=Microsoft" },
					stdin = true,
				},
				["json"] = {
					command = "jq",
					args = { "-S", "--indent", "2" },
					stdin = true,
				},
			},
			notify_on_error = false,
			format_on_save = { lsp_format = "fallback", timeout_ms = 500 },
			formatters_by_ft = {
				["*"] = { "codespell" },
				["_"] = { "trim_whitespace" },
				bash = { "shfmt" },
				c = { "clang-format-custom", lsp_format = "fallback" },
				cpp = { "clang-format", lsp_format = "fallback" },
				html = { "superhtml" },
				json = { "json" },
				lua = { "stylua" },
				rust = { "rustfmt", lsp_format = "fallback" },
				sh = { "shfmt" },
				toml = { "taplo" },
				python = { "ruff_format" },
				zig = { "zigfmt" },
				zsh = { "shfmt" },
				markdown = { "rumdl" },
				glsl = { "clang-format-custom", lsp_format = "fallback" },
			},
		})
	end,
})

autocmd("BufAdd", {
	desc = "nvim-highlight-colors setup",
	group = PluginLoaderGroup,
	once = true,
	callback = function()
		require("nvim-highlight-colors").setup({
			render = "background",
			enable_hex = true,
			enable_short_hex = false,
			enable_rgb = true,
			enable_hsl = true,
			enable_ansi = false,
			enable_xterm256 = true,
			enable_xtermTrueColor = true,
			enable_hsl_without_function = true,
			enable_var_usage = true,
			enable_named_colors = true,
			enable_tailwind = false,

			exclude_filetypes = {},
			exclude_buftypes = {},
			exclude_buffer = function(bufnr)
				return vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr)) > 100 * 1024
			end,
		})
	end,
})

----------------------------------colorscheme----------------------------------
----------------------------------colorscheme----------------------------------
----------------------------------colorscheme----------------------------------

local function hexToRgb(color)
	local hex = "[abcdef0-9][abcdef0-9]"
	local pat = "^#(" .. hex .. ")(" .. hex .. ")(" .. hex .. ")$"
	color = string.lower(color)
	assert(string.find(color, pat) ~= nil, "hex_to_rgb: invalid hex_str: " .. tostring(color))
	local r, g, b = string.match(color, pat)
	return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) }
end
local function blend(a, coeff, b)
	local A = hexToRgb(a)
	local B = hexToRgb(b)
	local alpha = math.abs(coeff)
	local blendChannel = function(i)
		local ret = ((1 - alpha) * B[i] + alpha * A[i])
		return math.floor(math.min(math.max(0, ret), 255) + 0.5)
	end
	return string.format("#%02X%02X%02X", blendChannel(1), blendChannel(2), blendChannel(3))
end
local ColorScheme = {
	theme = "khold",
	variant = "dark",
	alt_bg = false,
	colored_docstrings = false,
	cursorline_gutter = true,
	dark_gutter = false,
	plain_float = true,
	show_eob = false,
	term_colors = true,
	transparent = true,
	diagnostics = {
		darker = true, -- Darker colors for diagnostic
		undercurl = true, -- Use undercurl for diagnostics
		background = true, -- Use background color for virtual text
	},
	code_style = {
		comments = "bold,italic",
		conditionals = "none",
		functions = "none",
		keywords = "italic",
		headings = "bold", -- Markdown headings
		operators = "bold",
		keyword_return = "none",
		strings = "italic",
		variables = "none",
	},
	plugin = { cmp = { plain = false, reverse = false } },
	colors = {},
	highlights = {},
}
vim.g.colors_name = ColorScheme.theme
local c = {
	alt = "#5f8787",
	alt_bg = "#39121b",
	bg = "#000000",
	comment = "#505050",
	constant = "#aaaaaa",
	fg = "#c1c1c1",
	func = "#888888",
	keyword = "#999999",
	line = "#000000",
	number = "#aaaaaa",
	operator = "#9b99a3",
	property = "#c1c1c1",
	string = "#9b99a3",
	type = "#914b46",
	visual = "#333333",
	diag_red = "#5f8787",
	diag_blue = "#999999",
	diag_yellow = "#5f8787",
	diag_green = "#6e4c4c",
}
c.colormap = {
	black = ColorScheme.alt_bg,
	grey = ColorScheme.comment,
	red = ColorScheme.diag_red,
	orange = ColorScheme.number,
	green = ColorScheme.property,
	yellow = ColorScheme.func,
	blue = ColorScheme.constant,
	purple = ColorScheme.keyword,
	magenta = ColorScheme.type,
	cyan = ColorScheme.string,
	white = ColorScheme.fg,
}
local COMMON = {}
COMMON.ColorColumn = { bg = c.line }
COMMON.Conceal = { fg = c.func, bg = "none" }
COMMON.CurSearch = { fg = c.type, bg = c.visual }
COMMON.Cursor = { fmt = "reverse" }
COMMON.vCursor = { fmt = "reverse" }
COMMON.iCursor = { fmt = "reverse" }
COMMON.lCursor = { fmt = "reverse" }
COMMON.CursorIM = { fmt = "reverse" }
COMMON.CursorColumn = { bg = c.line }
COMMON.CursorLine = { bg = c.line }
COMMON.CursorLineNr = { fg = c.fg, bg = c.line }
COMMON.CursorLineSign = c.line
COMMON.CursorLineFold = { fg = c.fg, bg = c.line }
COMMON.Debug = { fg = c.operator }
COMMON.debugPC = { fg = c.diag_red }
COMMON.debugBreakpoint = { fg = c.diag_red }
COMMON.DiffAdd = { bg = blend(c.diag_green, 0.3, c.bg) }
COMMON.DiffChange = { bg = blend(c.diag_blue, 0.2, c.bg) }
COMMON.DiffDelete = { bg = blend(c.diag_red, 0.4, c.bg) }
COMMON.DiffText = { fg = c.fg }
COMMON.Directory = { fg = c.func }
COMMON.ErrorMsg = { fg = c.diag_red, fmt = "bold" }
COMMON.EndOfBuffer = { fg = c.bg }
COMMON.FloatBorder = { fg = c.comment, bg = "none" }
COMMON.FloatTitle = { fg = c.comment, bg = "none" }
COMMON.Folded = { fg = c.comment, bg = "none" }
COMMON.FoldColumn = { fg = c.comment, bg = "none" }
COMMON.IncSearch = { fg = c.type, bg = c.visual }
COMMON.LineNr = { fg = c.comment, bg = "none" }
COMMON.MatchParen = { fg = c.fg, bg = c.visual, fmt = "bold" }
COMMON.ModeMsg = { fg = c.fg, fmt = "bold" }
COMMON.MoreMsg = { fg = c.func, fmt = "bold" }
COMMON.MsgSeparator = { fg = c.string, bg = c.line, fmt = "bold" }
COMMON.NonText = { fg = c.comment }
COMMON.Normal = { fg = c.fg, bg = "none" }
COMMON.NormalFloat = { fg = c.fg, bg = "none" }
COMMON.Pmenu = { fg = c.fg, bg = "none" }
COMMON.PmenuSbar = { bg = c.line }
COMMON.PmenuSel = { fg = c.diag_blue, bg = "none" }
COMMON.PmenuThumb = { bg = c.visual }
COMMON.Question = { fg = c.constant }
COMMON.QuickFixLine = { fg = c.func, fmt = "underline" }
COMMON.Search = { fg = c.diag_blue, bg = c.visual }
COMMON.SignColumn = { fg = c.fg, bg = "none" }
COMMON.SpecialKey = { fg = c.comment }
COMMON.SpellBad = { fg = "none", fmt = "undercurl", sp = c.diag_red }
COMMON.SpellCap = { fg = "none", fmt = "undercurl", sp = c.diag_yellow }
COMMON.SpellLocal = { fg = "none", fmt = "undercurl", sp = c.diag_blue }
COMMON.SpellRare = { fg = "none", fmt = "undercurl", sp = c.diag_blue }
COMMON.StatusLine = { fg = c.comment, bg = c.line }
COMMON.StatusLineTerm = { fg = c.comment, bg = c.line }
COMMON.StatusLineNC = { fg = c.comment, bg = c.line }
COMMON.StatusLineTermNC = { fg = c.comment, bg = c.line }
COMMON.Substitute = { fg = c.type, bg = c.visual }
COMMON.TabLine = { fg = c.comment, bg = c.line }
COMMON.TabLineFill = { fg = c.comment, bg = c.line }
COMMON.TabLineSel = { fg = c.diag_blue, bg = c.visual }
COMMON.Terminal = { fg = c.fg, bg = "none" }
COMMON.ToolbarButton = { fg = c.bg, bg = c.visual }
COMMON.ToolbarLine = { fg = c.fg }
COMMON.Visual = { fg = c.alt, bg = c.visual }
COMMON.VisualNOS = { fg = "none", bg = c.comment, fmt = "underline" }
COMMON.WarningMsg = { fg = c.diag_yellow, fmt = "bold" }
COMMON.Whitespace = { fg = c.comment }
COMMON.WildMenu = { fg = c.diag_blue, bg = blend(c.diag_blue, 0.1, c.bg) }
COMMON.WinSeparator = { fg = c.comment }
local SYNTAX = {}
local code_style = {
	comments = "bold,italic",
	constants = "bold",
	conditionals = "none",
	functions = "none",
	keywords = "italic",
	headings = "bold", -- Markdown headings
	operators = "bold",
	keyword_return = "none",
	strings = "italic",
	variables = "none",
}
local diagnostics = {
	undercurl = false, -- Use undercurl for diagnostics
	background = true, -- Use background color for virtual text
}
local syntax = {
	Boolean = { fg = c.number }, -- boolean constants
	Character = { fg = c.string }, -- character constants
	Comment = { fg = c.comment, fmt = code_style.comments }, -- comments
	Constant = { fg = c.constant, fmt = code_style.constants }, -- (preferred) any constant
	Delimiter = { fg = c.fg }, -- delimiter characters
	Float = { fg = c.number }, -- float constants
	Function = { fg = c.func, fmt = code_style.functions }, -- functions
	Error = { fg = c.diag_red }, -- (preferred) any erroneous construct
	Exception = { fg = c.diag_red }, -- 'try', 'catch', 'throw'
	Identifier = { fg = c.property, fmt = code_style.variables }, -- (preferred) any variable
	Keyword = { fg = c.keyword, fmt = code_style.keywords }, -- any other keyword
	Conditional = { fg = c.keyword, fmt = code_style.conditionals }, -- conditionals
	-- Repeat = { fg = c.keyword, fmt = config.code_style.keywords }, -- loop keywords: 'for', 'while' etc
	-- Label = { fg = c.keyword }, -- 'case', 'default', etc
	Number = { fg = c.number }, -- number constant
	Operator = { fg = c.operator, fmt = code_style.operators }, -- '+', '*', 'sizeof' etc
	PreProc = { fg = c.string }, -- (preferred) generic preprocessor
	-- Define = { fg = c.comment }, -- preprocessor '#define'
	Include = { fg = c.constant, fmt = code_style.keywords }, -- preprocessor '#include'
	Macro = { fg = c.number, fmt = "italic" }, -- macros
	-- PreCondit = { fg = c.comment }, -- preprocessor conditionals '#if', '#endif' etc
	Special = { fg = c.type }, -- (preferred) any special symbol
	SpecialChar = { fg = c.keyword }, -- special character in a constant
	-- SpecialComment = { fg = c.keyword, fmt = config.code_style.comments }, -- special things inside comments
	-- Tag = { fg = c.func }, -- can use <C-]> on this
	Statement = { fg = c.keyword }, -- (preferred) any statement
	String = { fg = c.string, fmt = code_style.strings }, -- string constants
	Title = { fg = c.keyword },
	Type = { fg = c.type }, -- (preferred) 'int', 'long', 'char' etc
	-- StorageClass = { fg = c.constant, fmt = config.code_style.keywords }, -- 'static', 'volatile' etc
	-- Structure = { fg = c.constant }, -- 'struct', 'union', 'enum' etc
	-- Typedef = { fg = c.constant }, -- 'typedef'
	Todo = { fg = blend(c.comment, 0.6, c.fg), fmt = "bolditalic" }, -- (preferred) 'TODO' keywords in comments
}
SYNTAX.treesitter = {
	-- identifiers
	["@variable"] = { fg = c.fg, fmt = code_style.variables }, -- any variable that does not have another higM.ght
	["@variable.builtin"] = syntax["Type"], -- variable names that are defined by the language, like 'this' or 'self'
	["@variable.member"] = { fg = c.property }, -- fields
	["@variable.parameter"] = { fg = c.alt }, -- parameters of a function
	-- ["@variable.field"] = { fg = c.property }, -- fields
	-- ["@constant"] = { link = "Constant" }, -- constants
	["@constant.builtin"] = syntax["Type"], -- constants that are defined by the language, like 'nil' in lua
	-- ["@constant.macro"] = { link = "Macro" }, -- constants that are defined by macros like 'NULL' in c
	-- ["@label"] = { link = "Label" }, -- labels
	["@module"] = syntax["Type"], -- modules and namespaces
	-- literals
	-- ["@string"] = { link = "String" }, -- strings
	["@string.documentation"] = syntax["Comment"], -- doc strings
	["@string.regexp"] = syntax["SpecialChar"], -- regex
	["@string.escape"] = syntax["SpecialChar"], -- escape characters within string
	["@string.special.symbol"] = syntax["String"],
	-- ["@string.special.symbol"] = syntax["Identifier"],
	-- ["@string.special.url"] = { fg = c.func }, -- urls, links, emails
	-- ["@character"] = { link = "String" }, -- character literals
	-- ["@character.special"] = M.syntax["SpecialChar"], -- special characters
	-- ["@boolean"] = { link = "Constant" }, -- booleans
	-- ["@number"] = { link = "Number" }, -- all numbers
	-- ["@number.float"] = { link = "Number" }, -- floats
	-- types
	["@type"] = syntax["Type"], -- types
	-- ["@type.builtin"] = M.syntax["Type"], --builtin types
	-- ["@type.definition"] = M.syntax["Typedef"], -- typedefs
	-- ["@type.qualifier"]
	["@attribute"] = syntax["Function"], -- attributes, like <decorators> in python
	-- ["@property"] = { fg = c.property }, --same as TSField
	-- functions
	["@function"] = syntax["Function"], -- functions
	["@function.builtin"] = syntax["Function"], --builtin functions
	-- ["@function.macro"] = { link = "Macro" }, -- macro defined functions
	-- ["@function.call"]
	-- ["@function.method"]
	-- ["@function.method.call"]
	-- ["@constructor"] = { fg = c.constant, fmt = config.code_style.functions }, -- constructor calls and definitions
	["@constructor.lua"] = {
		fg = c.alt,
		fmt = code_style.functions,
	}, -- constructor calls and definitions, `= { }` in lua
	["@operator"] = syntax["Operator"], -- operators, like `+`
	-- keywords
	["@keyword"] = { fg = c.keyword, fmt = code_style.keywords }, -- keywords that don't fall in previous categories
	["@keyword.exception"] = syntax["Exception"], -- exception related keywords
	-- ["@keyword.import"] = M.syntax["PreProc"], -- keywords used to define a function
	["@keyword.conditional"] = {
		fg = c.keyword,
		fmt = code_style.conditionals,
	}, -- keywords for conditional statements
	["@keyword.operator"] = {
		fg = c.keyword,
		fmt = code_style.operators,
	}, -- keyword operator (eg, 'in' in python)
	["@keyword.return"] = {
		fg = c.keyword,
		fmt = code_style.keyword_return,
	}, -- keywords used to define a function
	-- ["@keyword.function"] = M.syntax["Function"], -- keywords used to define a function
	-- ["@keyword.import"] = M.syntax["Include"], -- includes, like '#include' in c, 'require' in lua
	-- ["@keyword.storage"] = M.syntax["StorageClass"], -- visibility/life-time 'static'
	-- ["@keyword.repeat"] = M.syntax["Repeat"], -- for keywords related to loops
	-- punctuation
	["@punctuation.delimiter"] = { fg = c.fg }, -- delimiters, like `; . , `
	["@punctuation.bracket"] = {
		fg = c.alt,
	}, -- brackets and parentheses
	["@punctuation.special"] = syntax["SpecialChar"], -- punctuation that does not fall into above categories, like `{}` in string interpolation
	-- comment
	-- ["@comment"]
	["@comment.error"] = {
		fg = blend(c.comment, 0.4, c.diag_red),
		fmt = "bolditalic",
	},
	["@comment.warning"] = {
		fg = blend(c.comment, 0.4, c.diag_yellow),
		fmt = "bolditalic",
	},
	["@comment.note"] = {
		fg = blend(c.comment, 0.4, c.diag_blue),
		fmt = "bolditalic",
	},
	-- markup
	["@markup"] = { fg = c.fg }, -- text in markup language
	["@markup.strong"] = { fg = c.fg, fmt = "bold" }, -- bold
	["@markup.italic"] = { fg = c.fg, fmt = "italic" }, -- italic
	["@markup.underline"] = { fg = c.fg, fmt = "underline" }, -- underline
	["@markup.strikethrough"] = {
		fg = c.comment,
		fmt = "strikethrough",
	}, -- strikethrough
	["@markup.heading"] = {
		fg = c.keyword,
		fmt = code_style.headings,
	}, -- markdown titles
	["@markup.quote.markdown"] = { fg = c.comment }, -- quotes with >
	["@markup.link.uri"] = { fg = c.alt, fmt = "underline" }, -- urls, links, emails
	["@markup.link"] = { fg = c.type }, -- text references, footnotes, citations, etc
	["@markup.list"] = { fg = c.func },
	["@markup.list.checked"] = { fg = c.func }, -- todo checked
	["@markup.list.unchecked"] = { fg = c.func }, -- todo unchecked
	["@markup.raw"] = { fg = c.func }, -- inline code in markdown
	["@markup.math"] = { fg = c.type }, -- math environments, like `$$` in latex
	-- diff
	["@diff.plus"] = { fg = c.diag_green }, -- added text (diff files)
	["@diff.minus"] = { fg = c.diag_red }, -- removed text (diff files)
	["@diff.delta"] = { fg = c.diag_blue }, -- changed text (diff files)
	-- tags
	-- ["@tag"]
	["@tag.attribute"] = syntax["Identifier"], -- tags, like in html
	["@tag.delimiter"] = { fg = c.fg }, -- tag delimiter < >
}
SYNTAX.lsp = {
	["@lsp.typemod.variable.global"] = {
		fg = blend(c.constant, 0.8, c.bg),
	},
	["@lsp.typemod.keyword.documentation"] = {
		fg = blend(c.type, 0.8, c.bg),
	},
	["@lsp.type.namespace"] = {
		fg = blend(c.constant, 0.8, c.bg),
	},
	["@lsp.type.macro"] = syntax["Macro"],
	["@lsp.type.parameter"] = SYNTAX.treesitter["@variable.parameter"],
	["@lsp.type.lifetime"] = { fg = c.type, fmt = "italic" },
	["@lsp.type.readonly"] = { fg = c.constant, fmt = "italic" },
	["@lsp.mod.readonly"] = { fg = c.constant, fmt = "italic" },
	["@lsp.mod.typeHint"] = syntax["Type"],
}
SYNTAX.diag = {
	DiagnosticError = { fg = c.diag_red },
	DiagnosticHint = { fg = c.diag_blue },
	DiagnosticInfo = { fg = c.diag_blue, fmt = "italic" },
	DiagnosticWarn = { fg = c.diag_yellow },
	DiagnosticVirtualTextError = {
		bg = diagnostics.background and blend(c.diag_red, 0.1, c.bg) or nil,
		fg = c.diag_red,
	},
	DiagnosticVirtualTextWarn = {
		bg = diagnostics.background and blend(c.diag_yellow, 0.1, c.bg) or nil,
		fg = c.diag_yellow,
	},
	DiagnosticVirtualTextInfo = {
		bg = diagnostics.background and blend(c.diag_blue, 0.1, c.bg) or nil,
		fg = c.diag_blue,
	},
	DiagnosticVirtualTextHint = {
		bg = diagnostics.background and blend(c.diag_blue, 0.1, c.bg) or nil,
		fg = c.diag_blue,
	},
	DiagnosticUnderlineError = {
		fmt = diagnostics.undercurl and "undercurl" or "underline",
		sp = c.diag_red,
	},
	DiagnosticUnderlineHint = {
		fmt = diagnostics.undercurl and "undercurl" or "underline",
		sp = c.diag_blue,
	},
	DiagnosticUnderlineInfo = {
		fmt = diagnostics.undercurl and "undercurl" or "underline",
		sp = c.diag_blue,
	},
	DiagnosticUnderlineWarn = {
		fmt = diagnostics.undercurl and "undercurl" or "underline",
		sp = c.diag_yellow,
	},
	LspReferenceText = { bg = c.visual },
	LspReferenceWrite = { bg = c.visual },
	LspReferenceRead = { bg = c.visual },
	LspCodeLens = {
		fg = c.keyword,
		bg = blend(c.keyword, 0.1, c.bg),
		fmt = code_style.comments,
	},
	LspCodeLensSeparator = { fg = c.comment },
}
SYNTAX.LspDiagnosticsDefaultError = SYNTAX.DiagnosticError
SYNTAX.LspDiagnosticsDefaultHint = SYNTAX.DiagnosticHint
SYNTAX.LspDiagnosticsDefaultInformation = SYNTAX.DiagnosticInfo
SYNTAX.LspDiagnosticsDefaultWarning = SYNTAX.DiagnosticWarn
SYNTAX.LspDiagnosticsUnderlineError = SYNTAX.DiagnosticUnderlineError
SYNTAX.LspDiagnosticsUnderlineHint = SYNTAX.DiagnosticUnderlineHint
SYNTAX.LspDiagnosticsUnderlineInformation = SYNTAX.DiagnosticUnderlineInfo
SYNTAX.LspDiagnosticsUnderlineWarning = SYNTAX.DiagnosticUnderlineWarn
SYNTAX.LspDiagnosticsVirtualTextError = SYNTAX.DiagnosticVirtualTextError
SYNTAX.LspDiagnosticsVirtualTextWarning = SYNTAX.DiagnosticVirtualTextWarn
SYNTAX.LspDiagnosticsVirtualTextInformation = SYNTAX.DiagnosticVirtualTextInfo
SYNTAX.LspDiagnosticsVirtualTextHint = SYNTAX.DiagnosticVirtualTextHint
SYNTAX.syntax = syntax
local PLUGIN = {}
PLUGIN.cmp = {
	CmpItemAbbr = { fg = c.fg },
	CmpItemAbbrDeprecated = { fg = c.comment, fmt = "strikethrough" },
	CmpItemAbbrMatch = { fg = c.type },
	CmpItemAbbrMatchFuzzy = { fg = c.type, fmt = "underline" },
	CmpItemMenu = { fg = c.comment },
	CmpItemKind = { fg = c.comment },
}
PLUGIN.blink = { BlinkCmpKind = { fg = c.comment } }
PLUGIN.diffview = {
	DiffviewFilePanelTitle = { fg = c.func, fmt = "bold" },
	DiffviewFilePanelCounter = { fg = c.alt, fmt = "bold" },
	DiffviewFilePanelFileName = { fg = c.fg },
	DiffviewNormal = { link = "Normal" },
	DiffviewCursorLine = { link = "CursorLine" },
	DiffviewVertSplit = { link = "VertSplit" },
	DiffviewSignColumn = { link = "SignColumn" },
	DiffviewStatusLine = { link = "StatusLine" },
	DiffviewStatusLineNC = { link = "StatusLineNC" },
	DiffviewEndOfBuffer = { link = "EndOfBuffer" },
	DiffviewFilePanelRootPath = { fg = c.comment },
	DiffviewFilePanelPath = { fg = c.comment },
	DiffviewFilePanelInsertions = { fg = c.fg },
	DiffviewFilePanelDeletions = { fg = c.operator },
	DiffviewStatusAdded = { fg = c.fg },
	DiffviewStatusUntracked = { fg = c.diag_blue },
	DiffviewStatusModified = { fg = c.diag_blue },
	DiffviewStatusRenamed = { fg = c.diag_blue },
	DiffviewStatusCopied = { fg = c.diag_blue },
	DiffviewStatusTypeChange = { fg = c.diag_blue },
	DiffviewStatusUnmerged = { fg = c.diag_blue },
	DiffviewStatusUnknown = { fg = c.diag_red },
	DiffviewStatusDeleted = { fg = c.diag_red },
	DiffviewStatusBroken = { fg = c.diag_red },
}
PLUGIN.gitsigns = {
	GitSignsAdd = { fg = c.diag_green },
	GitSignsAddLn = { fg = c.diag_green },
	GitSignsAddNr = { fg = c.diag_green },
	GitSignsAddCul = { fg = c.diag_green, bg = c.line },
	GitSignsChange = { fg = c.diag_blue },
	GitSignsChangeLn = { fg = c.diag_blue },
	GitSignsChangeNr = { fg = c.diag_blue },
	GitSignsChangeCul = { fg = c.diag_blue, bg = c.line },
	GitSignsDelete = { fg = c.diag_red },
	GitSignsDeleteLn = { fg = c.diag_red },
	GitSignsDeleteNr = { fg = c.diag_red },
	GitSignsDeleteCul = { fg = c.diag_red, bg = c.line },
}
PLUGIN.telescope = {
	TelescopeTitle = { fg = c.comment },
	TelescopeBorder = { fg = c.comment },
	TelescopeMatching = { fg = c.type, fmt = "bold" },
	TelescopePromptPrefix = { fg = c.type },
	TelescopeSelection = { fg = c.diag_blue, bg = nil },
	TelescopeSelectionCaret = { fg = c.diag_blue },
	TelescopeResultsNormal = { fg = c.fg },
}
local lsp_kind_icons_color = {
	Default = c.keyword,
	Array = c.keyword,
	Boolean = c.func,
	Class = c.type,
	Color = c.fg,
	Constant = c.constant,
	Constructor = c.constant,
	Enum = c.constant,
	EnumMember = c.property,
	Event = c.type,
	Field = c.property,
	File = c.fg,
	Folder = c.func,
	Function = c.func,
	Interface = c.constant,
	Key = c.keyword,
	Keyword = c.keyword,
	Method = c.func,
	Module = c.constant,
	Namespace = c.constant,
	Null = c.type,
	Number = c.func,
	Object = c.type,
	Operator = c.operator,
	Package = c.constant,
	Property = c.property,
	Reference = c.type,
	Snippet = c.type,
	String = c.string,
	Struct = c.keyword,
	Text = c.fg,
	TypeParameter = c.type,
	Unit = c.fg,
	Value = c.fg,
	Variable = c.fg,
}
for kind, color in pairs(lsp_kind_icons_color) do
	PLUGIN.cmp["BlinkCmpKind" .. kind] = { fg = color }
end
local function vim_highlights(highlights)
	for group, hi in pairs(highlights) do
		vim.api.nvim_set_hl(0, group, {
			fg = hi.fg,
			bg = hi.bg,
			sp = hi.sp,
			bold = hi.fmt == "bold" or nil,
			italic = hi.fmt == "italic" or nil,
			underline = hi.fmt == "underline" or nil,
			strikethrough = hi.fmt == "strikethrough" or nil,
		})
	end
end
vim_highlights(COMMON)
for _, group in pairs(SYNTAX) do
	vim_highlights(group)
end
for _, group in pairs(PLUGIN) do
	vim_highlights(group)
end
vim.hl.priorities.semantic_tokens = 95

----------------------------------greeter----------------------------------
----------------------------------greeter----------------------------------
----------------------------------greeter----------------------------------

local ascii_art = [[
 ██ ▄█▀ ██▀███   ▄▄▄        ▄████ 
 ██▄█▒ ▓██ ▒ ██▒▒████▄     ██▒ ▀█▒
▓███▄░ ▓██ ░▄█ ▒▒██  ▀█▄  ▒██░▄▄▄░
▓██ █▄ ▒██▀▀█▄  ░██▄▄▄▄██ ░▓█  ██▓
▒██▒ █▄░██▓ ▒██▒ ▓█   ▓██▒░▒▓███▀▒
▒ ▒▒ ▓▒░ ▒▓ ░▒▓░ ▒▒   ▓▒█░ ░▒   ▒ 
░ ░▒ ▒░  ░▒ ░ ▒░  ▒   ▒▒ ░  ░   ░ 
░ ░░ ░   ░░   ░   ░   ▒   ░ ░   ░ 
░  ░      ░           ░  ░      ░ 
]]

local ascii = vim.split(ascii_art, "\n")

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

local NamespaceGroup = vim.api.nvim_create_augroup("Greeter", { clear = true })

autocmd("VimEnter", {
	desc = "Greeter",
	group = NamespaceGroup,
	callback = function()
		if #vim.v.argv > 2 then
			return
		end

		vim.cmd.enew()
		local buf = vim.api.nvim_get_current_buf()

		autocmd("VimResized", {
			buffer = buf,
			desc = "Recalc and redraw greeter when window is resized",
			group = NamespaceGroup,
			callback = function()
				greeter_draw(buf)
			end,
		})

		autocmd("InsertEnter", {
			buffer = buf,
			desc = "Closes greeter and opens a new buffer",
			group = NamespaceGroup,
			callback = function()
				vim.schedule(vim.cmd.enew)
			end,
		})

		vim.keymap.set("n", "p", function()
			vim.schedule(function()
				vim.cmd.enew()
				vim.cmd("norm p")
			end)
		end, {
			buffer = buf,
			noremap = true,
			silent = true,
			desc = "Remap paste to open a new buffer",
		})
		vim.keymap.set("n", "q", ":q<cr>", {
			buffer = buf,
			noremap = true,
			silent = true,
			desc = "Quit nvim",
		})

		greeter_draw(buf)
	end,
})
