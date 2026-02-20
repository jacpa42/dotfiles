return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	cmd = "ConformInfo",
	opts = {
		formatters = {
			["clang-format-custom"] = { command = "clang-format", args = { "--style=LLVM" }, stdin = true },
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

		formatters_by_ft = {
			bash = { "shfmt" },
			c = { "clang-format-custom", lsp_format = "fallback" },
			cpp = { "clang-format", lsp_format = "fallback" },
			html = { "superhtml" },
			json = { "json" },
			lua = { "stylua" },
			rust = { "rustfmt", lsp_format = "fallback" },
			sh = { "shfmt" },
			tmux = { "shfmt" },
			toml = { "taplo" },
			python = { "ruff_format" },
			zig = { "zigfmt" },
			zsh = { "shfmt" },
			odin = { "odinfmt" },
		},
	},
}
