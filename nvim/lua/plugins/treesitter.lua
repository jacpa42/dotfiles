return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		highlight = { enable = true },
		indent = { enable = true },
		auto_install = true,
		sync_install = false,
	},
}
