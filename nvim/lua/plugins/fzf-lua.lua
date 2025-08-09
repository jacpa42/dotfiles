return {
	"ibhagwan/fzf-lua",
	cmd = "FzfLua",
	opts = {
		fzf_bin = "sk",
		fzf_colors = true,
		zoxide = {
			actions = {
				enter = function(selected)
					local dir = selected[1]:match("\t(.*)")
					vim.cmd.cd(dir)
					return require("fzf-lua").files({ cwd = dir })
				end,
			},
		},

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

		manpages = { previewer = "man_native" },
		helptags = { previewer = "help_native" },
		lsp = { code_actions = { previewer = "codeaction_native" } },
		tags = { previewer = "bat" },
		btags = { previewer = "bat" },
	},

	config = function(_, opts)
		require("fzf-lua").setup(opts)
		require("fzf-lua").register_ui_select()
	end,
}
