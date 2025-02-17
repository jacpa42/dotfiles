return {
	"williamboman/mason.nvim",
	dependencies = 'neovim/nvim-lspconfig',
	lazy = false,
	opts = {
		ensure_installed = { "lua_ls", "rust_analyzer", "basedpyright", "black" },
		automatic_installation = true,
	}
}
