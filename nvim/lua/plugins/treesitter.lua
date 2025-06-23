return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		highlight = { enable = true },
		indent = { enable = true },
		auto_install = true,
		sync_install = false,
		ensure_installed = {
			"c",
			"cpp",
			"lua",
			"rust",
			"glsl",
			"python",
			"hyprlang",
		},
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
	end,
}
