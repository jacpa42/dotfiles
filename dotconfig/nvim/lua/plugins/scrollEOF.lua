return {
	"Aasim-A/scrollEOF.nvim",
	event = { "CursorMoved", "WinScrolled" },
	opts = {
		pattern = "*",
		insert_mode = true,
		floating = false,
		disabled_filetypes = { "greeter", "lazy", "terminal", "vim" },
		disabled_modes = { "t", "nt" },
	},
}
