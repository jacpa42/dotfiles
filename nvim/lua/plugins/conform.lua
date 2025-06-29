return {
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
			rust = { "rustfmt", lsp_format = "fallback" },
			cpp = { "clang-format", lsp_format = "fallback" },
			c = {
				"clang-format-custom",
				lsp_format = "fallback",
			},
			glsl = { "clang-format", lsp_format = "fallback" },
		},
	},
}
