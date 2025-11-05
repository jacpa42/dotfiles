return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-telescope/telescope-ui-select.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	keys = {
		{
			mode = "n",
			"<space><space>",
			"<cmd>Telescope find_files hidden=true<cr>",
			desc = "find files",
		},

		{ mode = "n", "<space>c", "<cmd>Telescope commands<cr>", desc = "grep commands" },
		{ mode = "n", "<space>fc", "<cmd>Telescope colorscheme<cr>", desc = "grep colorschemes" },
		{ mode = "n", "<space>ff", "<cmd>Telescope live_grep<cr>", desc = "grep cwd" },
		{ mode = "n", "<space>fh", "<cmd>Telescope help_tags<cr>", desc = "grep help tags into float window" },
		{ mode = "n", "<space>fk", "<cmd>Telescope keymaps<cr>", desc = "search keymaps" },
		{ mode = "n", "<space>fm", "<cmd>Telescope marks<cr>", desc = "search marks" },
		{ mode = "n", "<space>fo", "<cmd>Telescope buffers<cr>", desc = "search open buffers" },
		{ mode = "n", "<space>fr", "<cmd>Telescope oldfiles<cr>", desc = "search recent files" },
		{ mode = "n", "<space>ft", "<cmd>Telescope diagnostics<cr>", desc = "get trouble for document" },
		{ mode = "n", "<space>t", "<cmd>Telescope lsp_type_definitions<cr>", desc = "get type definition" },
		{ mode = "n", "<space>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "get type definition" },
		{ mode = "n", "gr", "<cmd>Telescope lsp_references<cr>", desc = "find symbol references" },
		{ mode = "n", "gi", "<cmd>Telescope lsp_implementations<cr>", desc = "get lsp impls" },
		{ mode = "n", "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "goto symbol definition" },
		{
			mode = "n",
			"<space>a",
			function()
				vim.lsp.buf.code_action({})
			end,
			desc = "code actions",
		},
	},

	config = function()
		require("telescope").setup({
			defaults = { file_ignore_patterns = { "^.git/" } },
			extensions = {
				["ui-select"] = require("telescope.themes").get_dropdown({}),
				["fzf"] = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
				},
			},
		})
		require("telescope").load_extension("fzf")
		require("telescope").load_extension("ui-select")
	end,
}
