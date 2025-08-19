return {
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
