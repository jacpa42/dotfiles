return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		opts = {
			transparent_background = true,
			flavour = "mocha",
			show_end_of_buffer = false,
			term_colors = false,
			styles = {
				comments = { "italic" },
				conditionals = { "italic" },
				numbers = { "bold" },
				booleans = { "bold" },
			},
		},
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = true,
		opts = { transparent = true },
	},
}
