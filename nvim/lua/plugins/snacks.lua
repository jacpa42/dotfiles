return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		image = { enabled = true },
		picker = {
			enabled = true,
			sources = {
				explorer = {},
			},
		},

		lazygit = {
			configure = true,
			config = {
				os = { editPreset = "nvim-remote" },
				gui = {
					nerdFontsVersion = "3",
				},
			},
		},

		dashboard = {
			enabled = true,
			width = 60,
			row = nil, -- dashboard position. nil for center
			col = nil, -- dashboard position. nil for center
			pane_gap = 4, -- empty columns between vertical panes
			-- autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
			preset = {
				pick = nil,
				keys = {
					{
						icon = " ",
						key = "f",
						desc = "Find File",
						action = ":lua Snacks.dashboard.pick('files')",
					},
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{
						icon = " ",
						key = "g",
						desc = "Find Text",
						action = ":lua Snacks.dashboard.pick('live_grep')",
					},
					{
						icon = " ",
						key = "r",
						desc = "Recent Files",
						action = ":lua Snacks.dashboard.pick('oldfiles')",
					},
					{
						icon = " ",
						key = "c",
						desc = "Config",
						action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
					},
					{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
					{
						icon = "󰒲 ",
						key = "L",
						desc = "Lazy",
						action = ":Lazy",
						enabled = package.loaded.lazy ~= nil,
					},
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
				-- Used by the `header` section
				--
				header = [[
 ████╗     ████╗ ██████████═╗   ████████████╗ ██████████████╗
 ████║   █████╔╝████████████║   ████████████║ ██████████████║
 ████║ █████╔═╝ ████╔═══████║  ████╔═════████╗█████╔═══█████║
 █████████╔═╝   ████║   ████║  ████║     ████║█████║   ╚════╝
 ███████╔═╝     ████████████║  ██████████████║█████║  ██████╗
 █████████╗     ███████████╔╝  ██████████████║█████║  ██████║
 ████╔═█████╗   ████╔═══████╗  ████╔═════████║█████║  ╚═████║
 ████║ ╚═█████╗ ████║   ╚████╗ ████║     ████║██████████████║
 ████║   ╚═████╗████║    ╚████╗████║     ████║██████████████║
 ╚═══╝     ╚═══╝╚═══╝     ╚═══╝╚═══╝     ╚═══╝╚═════════════╝]],
			},
			-- item field formatters
			sections = {
				{ section = "header" },
				{ icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
				{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
				{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
				{ section = "startup" },
			},
		},
		indent = { enabled = false },
		input = { enabled = true },
		notifier = { enabled = false },
		quickfile = { enabled = true },
		scroll = { enabled = false },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		animate = { enabled = false },
	},
}
