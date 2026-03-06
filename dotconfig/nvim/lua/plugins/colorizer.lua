return {
	"catgoose/nvim-colorizer.lua",
	event = "BufReadPre",
	opts = {
		options = {
			parsers = { css_fn = true },
			display = {
				mode = "virtualtext",
				virtualtext = {
					position = "after",
					char = "█",
				},
			},
		},
	},
}
