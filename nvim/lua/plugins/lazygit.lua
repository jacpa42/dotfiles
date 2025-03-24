return {
	"kdheepak/lazygit.nvim",
	lazy = true,
	keys = {
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "LazyGit",
		},
	},
}
