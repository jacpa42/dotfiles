return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	opts = {
		fzf_colors = true,
		previewers = {
			cat = {
				cmd = "cat",
				args = "-n",
			},
			bat = {
				cmd = "bat",
				args = "--color=always --style=numbers,changes",
			},
			head = {
				cmd = "head",
				args = nil,
			},
			git_diff = {
				cmd_deleted = "git diff --color HEAD --",
				cmd_modified = "git diff --color HEAD",
				cmd_untracked = "git diff --color --no-index /dev/null",
			},
			man = {
				cmd = "man -c %s | col -bx",
			},
			builtin = {
				syntax = true, -- preview syntax highlight?
				syntax_limit_l = 0, -- syntax limit (lines), 0=nolimit
				syntax_limit_b = 1024 * 1024, -- syntax limit (bytes), 0=nolimit
				limit_b = 1024 * 1024 * 10, -- preview limit (bytes), 0=nolimit
				treesitter = {
					enabled = true,
					disabled = {},
					-- nvim-treesitter-context config options
					context = { max_lines = 1, trim_scope = "inner" },
				},
				extensions = {
					-- neovim terminal only supports `viu` block output
					["png"] = { "chafa" },
					["svg"] = { "chafa" },
					["jpg"] = { "chafa" },
				},
			},
			-- Code Action previewers, default is "codeaction" (set via `lsp.code_actions.previewer`)
			-- "codeaction_native" uses fzf's native previewer, recommended when combined with git-delta
			codeaction = {
				-- options for vim.diff(): https://neovim.io/doc/user/lua.html#vim.diff()
				diff_opts = { ctxlen = 3 },
			},
			codeaction_native = {
				diff_opts = { ctxlen = 3 },
				-- git-delta is automatically detected as pager, set `pager=false`
				-- to disable, can also be set under 'lsp.code_actions.preview_pager'
				-- recommended styling for delta
				--pager = [[delta --width=$COLUMNS --hunk-header-style="omit" --file-style="omit"]],
			},
		},
		winopts = {
			width = 0.9,
			height = 0.9,
			row = 0.5,
			col = 0.5,
			preview = {
				scrollchars = { "┃", "" },
			},
		},
	},
}
