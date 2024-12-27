return {
	"freddiehaddad/feline.nvim",
	config = function()
		vim.opt.termguicolors = true
		local line_ok, feline = pcall(require, "feline")
		if not line_ok then
			return
		end

		local theme = require("catppuccin.palettes").get_palette("macchiato")

		local vi_mode_colors = {
			NORMAL = "green",
			OP = "green",
			INSERT = "yellow",
			VISUAL = "mauve",
			LINES = "peach",
			BLOCK = "red",
			REPLACE = "maroon",
			COMMAND = "blue",
		}

		local c = {
			vim_mode = {
				provider = {
					name = "vi_mode",
					opts = {
						show_mode_name = true,
					},
				},
				hl = function()
					return {
						fg = require("feline.providers.vi_mode").get_mode_color(),
						bg = "base",
						style = "bold",
						-- name = "NeovimModeHLColor",
					}
				end,
				left_sep = "",
				right_sep = "block",
			},
			gitBranch = {
				provider = "git_branch",
				hl = {
					fg = "flamingo",
					bg = "base",
					style = "bold",
				},
				left_sep = "block",
				right_sep = "block",
			},
			gitDiffAdded = {
				provider = "git_diff_added",
				hl = {
					fg = "green",
					bg = "base",
				},
				left_sep = "block",
				right_sep = "block",
			},
			gitDiffRemoved = {
				provider = "git_diff_removed",
				hl = {
					fg = "red",
					bg = "base",
				},
				left_sep = "block",
				right_sep = "block",
			},
			gitDiffChanged = {
				provider = "git_diff_changed",
				hl = {
					fg = "surafce0",
					bg = "base",
				},
				left_sep = "block",
				right_sep = "right_filled",
			},
			separator = {
				provider = "",
				hl = {
					fg = "surafce0",
					bg = "base",
				},
			},
			fileinfo = {
				provider = {
					name = "file_info",
					opts = {
						type = "short",
					},
				},
				hl = {
					style = "bold",
					bg = "base",
				},
				left_sep = "",
				right_sep = "",
			},
			macroinfo = {
				provider = {
					name = "macro",
				},
				hl = {
					style = "bold",
					fg = "red",
					bg = "base",
				},
				left_sep = "block",
				right_sep = "block",
			},
			diagnostic_errors = {
				provider = "diagnostic_errors",
				hl = {
					fg = "red",
					bg = "base",
				},
			},
			diagnostic_warnings = {
				provider = "diagnostic_warnings",
				hl = {
					fg = "yellow",
					bg = "base",
				},
			},
			diagnostic_hints = {
				provider = "diagnostic_hints",
				hl = {
					fg = "sky",
					bg = "base",
				},
			},
			diagnostic_info = {
				provider = "diagnostic_info",
				hl = {
					fg = "sky",
					bg = "base",
				},
			},
			lsp_client_names = {
				provider = "lsp_client_names",
				hl = {
					fg = "mauve",
					bg = "base",
					style = "bold",
				},
				left_sep = "block",
				right_sep = "block",
			},
			file_type = {
				provider = {
					name = "file_type",
					opts = {
						filetype_icon = true,
						case = "titlecase",
					},
				},
				hl = {
					fg = "maroon",
					bg = "surface1",
					style = "bold",
				},
				left_sep = "block",
				right_sep = "block",
			},
			file_encoding = {
				provider = "file_encoding",
				hl = {
					fg = "peach",
					bg = "surface0",
					style = "italic",
				},
				left_sep = "block",
				right_sep = "block",
			},
			position = {
				provider = "position",
				hl = {
					fg = "green",
					bg = "surface0",
					style = "bold",
				},
				left_sep = "block",
				right_sep = "block",
			},
			line_percentage = {
				provider = "line_percentage",
				hl = {
					fg = "sky",
					bg = "surface0",
					style = "bold",
				},
				left_sep = "block",
				right_sep = "block",
			},
			scroll_bar = {
				provider = "scroll_bar",
				hl = {
					fg = "red",
					style = "bold",
				},
			},
		}

		local left = {
			c.vim_mode,
			c.gitBranch,
			c.gitDiffAdded,
			c.gitDiffRemoved,
			c.gitDiffChanged,
			-- c.separator,
			c.fileinfo,
			c.macroinfo,
			c.diagnostic_errors,
			c.diagnostic_warnings,
			c.diagnostic_info,
			c.diagnostic_hints,
		}

		local middle = {}

		local right = {
			c.lsp_client_names,
			-- c.file_type,
			-- c.file_encoding,
			c.position,
			-- c.line_percentage,
			c.scroll_bar,
		}

		local components = {
			active = {
				left,
				middle,
				right,
			},
			inactive = {
				left,
				middle,
				right,
			},
		}

		feline.setup({
			components = components,
			theme = theme,
			vi_mode_colors = vi_mode_colors,
		})
	end,
}
