-- fix: 2%+fsfjsf
-- todo:  2%+fsfjsf
-- hack:  2%+fsfjsf
-- warn:  2%+fsfjsf
-- perf:  2%+fsfjsf
-- note:  2%+fsfjsf
-- test:  2%+fsfjsf

return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = "VeryLazy",
	opts = {
		signs = false,
		keywords = {
			fix = {
				icon = " ", -- icon used for the sign, and in search results
				color = "error", -- can be a hex color, or a named color (see below)
				alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
				-- signs = false, -- configure signs for some keywords individually
			},
			todo = { icon = " ", color = "info" },
			hack = { icon = " ", color = "warning" },
			warn = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
			perf = { icon = " ", color = "warning", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
			note = { icon = " ", color = "hint", alt = { "INFO" } },
			test = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
		},
		gui_style = {
			fg = "BOLD", -- The gui style to use for the fg highlight group.
			bg = "BOLD", -- The gui style to use for the bg highlight group.
		},
		merge_keywords = true,
		highlight = {
			multiline = true, -- enable multine todo comments
			multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
			multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
			before = "fg", -- "fg" or "bg" or empty
			keyword = "wide_fg", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
			after = "empty", -- "fg" or "bg" or empty
			pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
			comments_only = true, -- uses treesitter to match keywords in comments only
			max_line_len = 400, -- ignore lines longer than this
			exclude = {}, -- list of file types to exclude highlighting
		},
		colors = {
			error = "MiniIconsRed",
			warning = "MiniIconsOrange",
			info = "MiniIconsGreen",
			hint = "MiniIconsPurple",
			default = "MiniIconsBlue",
			test = "MiniIconsPurple",
		},
		search = {
			command = "rg",
			args = {
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
			},
			pattern = [[\b(KEYWORDS):]],
			-- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
		},
	},
}
