return {
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
		cmdline = { enabled = true },
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
}
