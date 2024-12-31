return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	dependencies = { 'echasnovski/mini.icons', 'nvim-lua/plenary.nvim' },
	config = function()
		local dashboard = require("alpha.themes.theta")
		print(dashboard)

		dashboard.header.val = {
			"                                                             ",
			"                                                             ",
			"                                                             ",
			"                                                             ",
			"                                                             ",
			"                                                             ",
			"                                                             ",
			" ████╗     ████╗ ██████████═╗   ████████████╗ ██████████████╗",
			" ████║   █████╔╝████████████║   ████████████║ ██████████████║",
			" ████║ █████╔═╝ ████╔═══████║  ████╔═════████╗█████╔═══█████║",
			" █████████╔═╝   ████║   ████║  ████║     ████║█████║   ╚════╝",
			" ███████╔═╝     ████████████║  ██████████████║█████║  ██████╗",
			" █████████╗     ███████████╔╝  ██████████████║█████║  ██████║",
			" ████╔═█████╗   ████╔═══████╗  ████╔═════████║█████║  ╚═████║",
			" ████║ ╚═█████╗ ████║   ╚████╗ ████║     ████║██████████████║",
			" ████║   ╚═████╗████║    ╚████╗████║     ████║██████████████║",
			" ╚═══╝     ╚═══╝╚═══╝     ╚═══╝╚═══╝     ╚═══╝╚═════════════╝",
		}

		function centerText(text, width)
			local totalPadding = width - #text
			local leftPadding = math.floor(totalPadding / 2)
			local rightPadding = totalPadding - leftPadding
			return pad(text, leftPadding, rightPadding)
		end

		function pad(text, left, right)
			return string.rep(" ", left) .. text .. string.rep(" ", right)
		end

		table.insert(dashboard.config.layout, { type = "padding", val = 2 })
		local motivational_quote = {
			type = "text",
			val = {
				"おれは海賊王になる男だ"
			},
			opts = {
				position = "center",
				hl = "Type",
			},
		}
		table.insert(dashboard.config.layout, motivational_quote)
		table.remove(dashboard.config.layout, 5)
		table.remove(dashboard.config.layout, 5)

		require("alpha").setup(dashboard.config)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
