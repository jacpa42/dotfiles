return {
	"mfussenegger/nvim-dap",
	event = "VeryLazy",
	dependencies = { "igorlfs/nvim-dap-view" },
	keys = {
		{ mode = "n", "<leader>b", "<cmd>DapToggleBreakpoint<cr>", desc = "toggle breakpoint" },
		{ mode = "n", "<c-right>", "<cmd>DapContinue<cr>", desc = "continue until next breakpoint" },
		{ mode = "n", "<right>", "<cmd>DapStepInto<cr>", desc = "dap step into" },
		{ mode = "n", "<down>", "<cmd>DapStepOver<cr>", desc = "dap step over" },
		{ mode = "n", "<up>", "<cmd>DapStepOut<cr>", desc = "dap step out" },
	},
	config = function()
		local dapview = require("dap-view")
		dapview.setup()

		local dap = require("dap")

		dap.listeners.before.attach.dapui_config = function()
			dapview.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapview.open()
		end

		dap.adapters.lldb = {
			type = "executable",
			command = "/usr/bin/codelldb",
			name = "lldb",
		}

		-- setup a debugger config for zig projects
		dap.configurations.zig = {
			{
				name = "Launch",
				type = "lldb",
				request = "launch",
				program = function()
					-- Run zig build before launching
					vim.fn.system("zig build -Doptimize=Debug")
					return "${workspaceFolder}/zig-out/bin/${workspaceFolderBasename}"
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				args = {},
			},
		}
	end,
}
