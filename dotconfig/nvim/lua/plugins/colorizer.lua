return {
	"catgoose/nvim-colorizer.lua",
	event = "BufReadPre",
	opts = {
		options = {
			parsers = { css = true },
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
