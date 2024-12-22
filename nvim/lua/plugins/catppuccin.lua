return { 
	"catppuccin/nvim", 
	name = "catppuccin", 
	priority = 1000,
	opts = {
	    flavour = "macchiato",
	    transparent_background = true,
	    show_end_of_buffer = false,
	    term_colors = false,
	    styles = { 
		comments = { "italic" },
		conditionals = { "italic" },
		loops = {},
		functions = {},
		keywords = {},
		strings = {},
		variables = {},
		numbers = { "bold" },
		booleans = { "bold" },
		properties = {},
		types = {},
		operators = {},
	    },
	}
}
