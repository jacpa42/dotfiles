return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		timeout = 1000,
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
			},
		},
		presets = {
			bottom_search = false,
			command_palette = true, -- position the cmdline and popupmenu together
			long_message_to_split = true, -- long messages will be sent to a split
			inc_rename = false, -- enables an input dialog for inc-rename.nvim
			lsp_doc_border = true, -- add a border to hover docs and signature help
		},
	},
	config = function(_, opts)
		require("noice").setup(opts)

		vim.cmd("hi DiagnosticSignInfo  guibg=None<cr>")
		vim.cmd("hi DiagnosticSignWarn  guibg=None<cr>")
		vim.cmd("hi DiagnosticSignError guibg=None<cr>")
		vim.cmd("hi DiagnosticSignHint  guibg=None<cr>")
	end,
}
