return {
	"mason-org/mason.nvim",
	event = "VeryLazy",
	opts = {
		ui = {
			icons = {
				package_installed = "󰦥 ", -- 
				package_pending = " ", -- 󱑢
				package_uninstalled = " ", -- 
			},
		},

		-- Some I expect to have installed
		-- clangd (keywords: c, c++)
		-- rust-analyzer (keywords: rust)
		-- lua-language-server (keywords: lua)
		-- hyprls (keywords: hypr)
		-- zls (keywords: zig)
	},
}
