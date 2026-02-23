return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		highlight = {
			enable = true,
			disable = function(_, buf)
				local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > 100 * 1024 then
					print("disabling treesitter for " .. buf)
					return true
				end
			end,
		},
		indent = { enable = true },
		auto_install = false,
		sync_install = false,
	},
}
