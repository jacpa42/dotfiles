return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	opts = function(_, opts)
		local config = require("fzf-lua.config")
		local actions = require("fzf-lua.actions")

		-- Quickfix
		config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
		config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
		config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
		config.defaults.keymap.fzf["ctrl-x"] = "jump"
		config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
		config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
		config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
		config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"

		local img_previewer ---@type string[]?
		for _, v in ipairs({
			{ cmd = "ueberzug", args = {} },
			{ cmd = "chafa", args = { "{file}", "--format=symbols" } },
			{ cmd = "viu", args = { "-b" } },
		}) do
			if vim.fn.executable(v.cmd) == 1 then
				img_previewer = vim.list_extend({ v.cmd }, v.args)
				break
			end
		end

		return {
			"default-title",
			fzf_colors = true,
			fzf_opts = {
				["--no-scrollbar"] = true,
			},
			defaults = {
				-- formatter = "path.filename_first",
				formatter = "path.dirname_first",
			},
			previewers = {
				builtin = {
					extensions = {
						["png"] = img_previewer,
						["jpg"] = img_previewer,
						["jpeg"] = img_previewer,
						["gif"] = img_previewer,
						["webp"] = img_previewer,
					},
					ueberzug_scaler = "fit_contain",
				},
			},
			winopts = {
				width = 0.8,
				height = 0.8,
				row = 0.5,
				col = 0.5,
				preview = {
					scrollchars = { "┃", "" },
				},
			},
			files = {
				cwd_prompt = false,
				actions = {
					["ctrl-i"] = { actions.toggle_ignore },
					["ctrl-h"] = { actions.toggle_hidden },
				},
			},
			grep = {
				actions = {
					["ctrl-i"] = { actions.toggle_ignore },
					["ctrl-h"] = { actions.toggle_hidden },
				},
			},
			lsp = {
				symbols = {
					symbol_hl = function(s)
						return "TroubleIcon" .. s
					end,
					symbol_fmt = function(s)
						return s:lower() .. "\t"
					end,
					child_prefix = false,
				},
				code_actions = {
					previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
				},
			},
		}
	end,
}
