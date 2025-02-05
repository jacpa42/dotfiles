return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { 'BufReadPost', 'BufNewFile' },
	opts = {
		ensure_installed = { "c", "lua", "rust", "zig", "python", "hyprlang" },
		sync_install = false,
		auto_install = true,
		highlight = { enable = true },
		indent = { enable = true },
	}
}
