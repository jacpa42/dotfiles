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
