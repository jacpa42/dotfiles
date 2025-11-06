return {
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
			html = { "superhtml" },
			zsh = { "shfmt" },
			tmux = { "shfmt" },
			json = { "jq" },
			rust = { "rustfmt", lsp_format = "fallback" },
			cpp = { "clang-format", lsp_format = "fallback" },
			c = { "clang-format-custom", lsp_format = "fallback" },
		},
	},
}
