----------------------------------opts----------------------------------
----------------------------------opts----------------------------------
----------------------------------opts----------------------------------

vim.diagnostic.config({ virtual_text = { current_line = false } })
vim.filetype.add({ pattern = { [".*/hypr/.*%.conf"] = "hyprlang" } })

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
vim.o.smartcase = true
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
vim.o.textwidth = 100
vim.o.formatoptions = "cro"

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

		vim.o.makeprg = not starts_with(vim.o.makeprg, "cargo") and compile or vim.o.makeprg
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

		vim.o.makeprg = not starts_with(vim.o.makeprg, "zig build") and compile or vim.o.makeprg
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

autocmd({ "TextYankPost" }, {
	desc = "Highlight when yanking",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank({ timeout = 80 })
	end,
})

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
map("n", "<m-c>", "<cmd>tabnew +terminal term <cr>i", { desc = "new terminal tab" })
map(
	"t",
	"<m-c>",
	"<c-\\><c-n><cmd>tabnew +terminal term<cr>i",
	{ noremap = true, silent = true, desc = "new terminal tab" }
)
map("t", "<m-esc>", "<c-\\><c-n>", { noremap = true, silent = true, desc = "escape out of terminal mode" })
map("n", "<m-y>", "<cmd>tabnew +terminal\\ yazi<cr>i", { noremap = true, silent = true, desc = "yazi" })

map("n", "gr", vim.lsp.buf.references, { desc = "find symbol references" })
map("n", "gd", vim.lsp.buf.definition, { desc = "find symbol definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "find symbol decl" })

map("n", "<leader>m", "<cmd>make <bar> copen<cr>", { desc = "make project", noremap = true })
map("n", "<leader>M", function()
	local makecmd = vim.fn.input("edit makeprg=", vim.o.makeprg, "file")
	if makecmd:len() > 0 then
		print('makecmd = "' .. makecmd .. '"')
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
map("n", "<leader>d", "<cmd>bd<cr>", { noremap = true, silent = true })

map("n", "<leader>h", "<cmd>split<cr>")
map("n", "<leader>v", "<cmd>vsplit<cr>")
map("n", "<leader>l", vim.pack.update)
map("n", "<leader>r", vim.lsp.buf.rename, { noremap = true, silent = true })

map("n", "<c-n>", "<cmd>cnext<cr>", { noremap = true, silent = true })
map("n", "<c-p>", "<cmd>cprev<cr>", { noremap = true, silent = true })

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

map("t", "<m-r>", "<c-\\><c-n><cmd>tabn<cr>", { noremap = true, silent = true, desc = "next tab" })
map("t", "<m-e>", "<c-\\><c-n><cmd>tabp<cr>", { noremap = true, silent = true, desc = "previous tab" })

map("n", "<m-r>", "<cmd>tabn<cr>", { noremap = true, silent = true, desc = "next tab" })
map("n", "<m-e>", "<cmd>tabp<cr>", { noremap = true, silent = true, desc = "previous tab" })

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

local gh = function(plugin)
	return "https://github.com/" .. plugin
end

-- treesitter
if true then
	vim.pack.add({
		gh("nvim-treesitter/nvim-treesitter"),
	})
	require("nvim-treesitter").setup({
		highlight = {
			enable = true,
			disable = function()
				local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > 100 * 1024 then
					print("disabling treesitter for " .. buf)
					return true
				end
			end,
		},
		indent = { enable = true },
		auto_install = true,
		sync_install = true,
	})
end

-- telescope
if true then
	vim.pack.add({
		gh("nvim-lua/plenary.nvim"), -- dependency
		gh("nvim-tree/nvim-web-devicons"), -- dependency
		gh("nvim-telescope/telescope-ui-select.nvim"), -- dependency
		gh("nvim-telescope/telescope.nvim"),
	})
	require("telescope").setup({
		defaults = { file_ignore_patterns = { "^.git/" } },
		extensions = {
			["ui-select"] = require("telescope.themes").get_dropdown({}),
		},
	})
	require("telescope").load_extension("ui-select")
end

-- oil
if true then
	vim.pack.add({
		gh("nvim-tree/nvim-web-devicons"), -- dependency
		gh("stevearc/oil.nvim"),
	})
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
			sort = {
				{ "type", "asc" },
				{ "name", "asc" },
			},
			highlight_filename = function()
				return nil
			end,
		},
	})
end

-- blink
if true then
	vim.pack.add({
		gh("rafamadriz/friendly-snippets"), -- dependency
		{ src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") },
	})
	require("blink.cmp").setup({
		appearance = {
			nerd_font_variant = "mono",
			use_nvim_cmp_as_default = false,
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "cmdline" },
		},
		cmdline = { enabled = true },
		fuzzy = { implementation = "prefer_rust_with_warning" },
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
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
			},
			accept = { auto_brackets = { enabled = false } },
		},
		keymap = {
			["<c-space>"] = { "select_and_accept" },
			["<c-j>"] = { "select_next", "fallback" },
			["<c-k>"] = { "select_prev", "fallback" },
		},
	})
end

-- nvim-dap
if true then
	vim.pack.add({
		gh("igorlfs/nvim-dap-view"), -- dependency
		gh("mfussenegger/nvim-dap"),
	})
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
				-- Run zig build before launching
				vim.fn.system("zig build -Doptimize=Debug")
				return "${workspaceFolder}/zig-out/bin/${workspaceFolderBasename}"
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			args = {},
		},
	}
end

-- conform
if true then
	vim.pack.add({
		gh("stevearc/conform.nvim"),
	})
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
			["odinfmt"] = {
				command = "odinfmt",
				args = { "-stdin" },
				stdin = true,
			},
		},

		notify_on_error = false,
		format_on_save = {
			-- I recommend these options. See :help conform.format for details.
			lsp_format = "fallback",
			timeout_ms = 500,
		},

		formatters_by_ft = {
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
			odin = { "odinfmt" },
			markdown = { "rumdl" },
			glsl = { "clang-format-custom", lsp_format = "fallback" },
		},
	})
end

-- kanagawa
if true then
	vim.pack.add({
		gh("rebelot/kanagawa.nvim"),
	})
	require("kanagawa").setup({ transparent = true })
	local hi = vim.cmd.hi
	vim.cmd.colorscheme("kanagawa")
	hi({ args = { "TelescopeBorder", "guibg=NONE" } })
	hi({ args = { "FloatBorder", "guibg=NONE" } })
	hi({ args = { "NormalFloat", "guibg=NONE" } })
	hi({ args = { "FloatTitle", "guibg=NONE" } })
	hi({ args = { "LineNr", "guibg=NONE" } })
	hi({ args = { "DiagnosticSignInfo", "guibg=NONE" } })
	hi({ args = { "DiagnosticSignWarn", "guibg=NONE" } })
	hi({ args = { "DiagnosticSignError", "guibg=NONE" } })
	hi({ args = { "DiagnosticSignHint", "guibg=NONE" } })
	hi({ args = { "StatusLine", "guibg=NONE" } })
	hi({ args = { "SignColumn", "guibg=NONE" } })
	hi({ args = { "CursorLineNr", "guibg=NONE" } })
end

-- epic experimental ui
require("vim._core.ui2").enable({
	enable = true,
	msg = {
		targets = { "cmd", "msg", "pager", "dailog" },
		cmd = { height = 0.5 },
		dialog = { height = 0.5 },
		msg = { height = 0.5 },
		pager = { height = 10 },
	},
})

----------------------------------greeter----------------------------------
----------------------------------greeter----------------------------------
----------------------------------greeter----------------------------------

if #vim.v.argv > 2 then
	return
end

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

vim.api.nvim_create_autocmd("InsertEnter", {
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
