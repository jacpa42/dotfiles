return {
	"neovim/nvim-lspconfig",
	dependencies = { "saghen/blink.cmp", "folke/lazydev.nvim" },

	opts = {
		servers = {
			lua_ls = {},
			zls = {},
			rust_analyzer = {},
			html = {},
			cssls = {},
			taplo = {},
			marksman = {},
			hyprls = {},
		},
	},

	config = function(_, opts)
		local lspconfig = require("lspconfig")
		for server, config in pairs(opts.servers) do
			-- passing config.capabilities to blink.cmp merges with the capabilities in your
			-- `opts[server].capabilities, if you've defined it
			config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
			lspconfig[server].setup(config)
		end
	end,
}
