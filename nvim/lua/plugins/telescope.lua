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
			"<leader><leader>",
			"<cmd>Telescope find_files hidden=true<cr>",
			desc = "find files",
		},
		{ mode = "n", "<leader>tt", "<cmd>Telescope<cr>", desc = "search telescope commands" },
		{ mode = "n", "<leader>fc", "<cmd>Telescope colorscheme<cr>", desc = "search colorschemes" },
		{ mode = "n", "<leader>ff", "<cmd>Telescope live_grep<cr>", desc = "search cwd" },
		{ mode = "n", "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "search help tags into float window" },
		{ mode = "n", "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "search keymaps" },
		{ mode = "n", "<leader>fm", "<cmd>Telescope marks<cr>", desc = "search marks" },
		{ mode = "n", "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "search open buffers" },
		{ mode = "n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "search recent files" },
		{ mode = "n", "<leader>ft", "<cmd>Telescope diagnostics<cr>", desc = "get trouble for document" },
		{ mode = "n", "<leader>t", "<cmd>Telescope lsp_type_definitions<cr>", desc = "get type definition" },
		{ mode = "n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "get type definition" },
		{ mode = "n", "gi", "<cmd>Telescope lsp_implementations<cr>", desc = "get methods for type" },
		{
			mode = "n",
			"<leader>a",
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
			},
		})
		require("telescope").load_extension("ui-select")
	end,
}
