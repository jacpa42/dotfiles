return {
	"ibhagwan/fzf-lua",
	cmd = "FzfLua",
	opts = {
		fzf_bin = "sk",
		fzf_colors = true,

		winopts = {
			width = 0.9,
			height = 0.9,
			row = 0.5,
			col = 0.5,
			preview = {
				scrollchars = { "┃", "" },
				default = "bat",
				treesitter = false,
			},
		},

		zoxide = {
			actions = {
				enter = function(selected)
					local dir = selected[1]:match("\t(.*)")
					vim.cmd.cd(dir)
					return require("fzf-lua").files({ cwd = dir })
				end,
			},
		},

		helptags = {
			previewer = "help_native",
			actions = {
				enter = function(items)
					local topic = items[1]:match("^[^%s]+")

					-- Close any help buffers if they exist?
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						if vim.bo[buf].filetype == "help" then
							vim.api.nvim_buf_delete(buf, {})
						end
					end

					local popup = require("nui.popup")({
						enter = true,
						relative = "editor",
						focusable = true,
						border = { style = "rounded" },
						position = "50%",
						size = { width = "60%", height = "80%" },
						buf_options = { buftype = "help", swapfile = false },
					})

					popup:mount()

					vim.api.nvim_buf_call(popup.bufnr, function()
						vim.cmd("help " .. topic)
					end)

					popup:map("n", "q", function()
						popup:unmount()
					end)
					popup:on("BufLeave", function()
						popup:unmount()
					end, { once = true })
				end,
			},
		},

		manpages = { previewer = "man_native" },
		lsp = { code_actions = { previewer = "codeaction_native" } },
		tags = { previewer = "bat" },
		btags = { previewer = "bat" },
	},

	config = function(_, opts)
		require("fzf-lua").setup(opts)
		require("fzf-lua").register_ui_select()
	end,
}
