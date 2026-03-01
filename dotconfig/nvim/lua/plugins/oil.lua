return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	keys = {
		{
			"<space>e",
			desc = "File tree",
			function()
				vim.cmd("edit " .. (vim.fn.expand("%:p:h") ~= "" and vim.fn.expand("%:p:h") or "."))
			end,
		},
	},

	init = function()
		if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
			require("lazy").load({ plugins = { "oil.nvim" } })
			vim.cmd("Oil " .. vim.fn.argv(0))
		end
	end,

	opts = {
		columns = { "icon", "size" },
		delete_to_trash = false,
		skip_confirm_for_simple_edits = true,
		prompt_save_on_select_new_entry = true,
		cleanup_delay_ms = 2000,
		lsp_file_methods = {
			enabled = true,
			timeout_ms = 1000,
			autosave_changes = true,
		},
		constrain_cursor = "editable",
		watch_for_changes = true,
		keymaps = {
			["gh"] = { "actions.show_help", mode = "n" },
			["<CR>"] = "actions.select",
			["<leader>v"] = { "actions.select", opts = { vertical = true } },
			["<leader>h"] = { "actions.select", opts = { horizontal = true } },
			["<leader>p"] = "actions.preview",
			["<C-l>"] = "actions.refresh",
			["<leader>."] = { "actions.toggle_hidden", mode = "n" },
		},
		use_default_keymaps = false,
		view_options = {
			show_hidden = true,
			is_hidden_file = function(name)
				return name:match("^%.") ~= nil
			end,
			-- This function defines what will never be shown, even when `show_hidden` is set
			is_always_hidden = function()
				return false
			end,
			natural_order = "fast",
			case_insensitive = false,
			sort = {
				{ "type", "asc" },
				{ "name", "asc" },
			},
			highlight_filename = function()
				return nil
			end,
		},
	},
}
