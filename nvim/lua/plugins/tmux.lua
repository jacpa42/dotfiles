return {
	"aserowy/tmux.nvim",
	keys = {
		{
			"<M-j>",
			function()
				require("tmux").move_bottom()
			end,
			{ noremap = true, silent = true },
			desc = "move down",
		},
		{
			"<M-k>",
			function()
				require("tmux").move_top()
			end,
			{ noremap = true, silent = true },
			desc = "move up",
		},
		{
			"<M-h>",
			function()
				require("tmux").move_left()
			end,
			{ noremap = true, silent = true },
			desc = "move left",
		},
		{
			"<M-l>",
			function()
				require("tmux").move_right()
			end,
			{ noremap = true, silent = true },
			desc = "move right",
		},
	},
	opts = {
		copy_sync = {
			enable = false,
			ignore_buffers = { empty = false },
			redirect_to_clipboard = false,
			register_offset = 0,
			sync_clipboard = false,
			sync_registers = false,
			sync_registers_keymap_put = false,
			sync_registers_keymap_reg = false,
			sync_deletes = false,
			sync_unnamed = false,
		},
		navigation = {
			cycle_navigation = true,
			enable_default_keybindings = false,
			persist_zoom = false,
		},
		resize = {
			enable_default_keybindings = false,
			resize_step_x = 1,
			resize_step_y = 1,
		},
		swap = {
			cycle_navigation = false,
			enable_default_keybindings = false,
		},
	},
}
