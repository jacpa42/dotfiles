return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = "VeryLazy",

	-- FIX: this is a random comment
	-- fix: this is a random comment
	-- fixme: this is a random comment
	-- FIXME: this is a random comment
	-- bug: this is a random comment
	-- BUG: this is a random comment
	-- fixit: this is a random comment
	-- FIXIT: this is a random comment
	-- issue: this is a random comment
	-- ISSUE: this is a random comment
	-- TODO: this is a random comment
	-- todo: this is a random comment
	-- HACK: this is a random comment
	-- hack: this is a random comment
	-- WARN: this is a random comment
	-- warn: this is a random comment
	-- WARNING: this is a random comment
	-- warning: this is a random comment
	-- XXX: this is a random comment
	-- xxx: this is a random comment
	-- PERF: this is a random comment
	-- perf: this is a random comment
	-- OPTIM: this is a random comment
	-- optim: this is a random comment
	-- PERFORMANCE: this is a random comment
	-- performance: this is a random comment
	-- OPTIMIZE: this is a random comment
	-- optimize: this is a random comment
	-- NOTE: this is a random comment
	-- note: this is a random comment
	-- INFO: this is a random comment
	-- info: this is a random comment
	-- TEST: this is a random comment
	-- test: this is a random comment
	-- TESTING: this is a random comment
	-- testing: this is a random comment
	-- PASSED: this is a random comment
	-- passed: this is a random comment
	-- FAILED: this is a random comment
	-- failed: this is a random comment
	opts = {
		signs = false,
		keywords = {
			FIX = {
				icon = " ", -- icon used for the sign, and in search results
				color = "error", -- can be a hex color, or a named color (see below)
				alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this fix keywords
				-- signs = false, -- configure signs for some keywords individually
			},
			TODO = { icon = " ", color = "blue", alt = {} }, -- failed: this is a random comment
			HACK = { icon = " ", color = "yellow", alt = {} },
			WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
			PERF = {
				icon = " ",
				color = "error",
				alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" },
			},
			NOTE = { icon = " ", color = "blue", alt = { "INFO" } },
			TEST = {
				icon = "⏲ ",
				color = "test",
				alt = { "TESTING", "PASSED", "FAILED" },
			},
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
			before = "", -- "fg" or "bg" or empty
			keyword = "wide_bg", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
			after = "fg", -- "fg" or "bg" or empty
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
			yellow = "MiniIconsYellow",
			blue = "MiniIconsBlue",
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
