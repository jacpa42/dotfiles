return {
	"ibhagwan/fzf-lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		{
			"allaman/emoji.nvim",
			cmd = "Emoji",
			config = function(_, opts)
				require("emoji").setup(opts)
				require("fzf-lua").register_ui_select()
			end,
		},
	},
	cmd = "FzfLua",
	opts = {
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
			},
		},
	},
}
