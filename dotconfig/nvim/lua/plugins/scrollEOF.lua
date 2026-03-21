return {
	"Aasim-A/scrollEOF.nvim",
	event = { "CursorMoved", "WinScrolled" },
	opts = {
		pattern = "*",
		insert_mode = true,
		floating = true,
		disabled_modes = { "t", "nt" },
	},
}
