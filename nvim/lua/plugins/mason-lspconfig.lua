return {
	"williamboman/mason.nvim",
	dependencies = "neovim/nvim-lspconfig",
	lazy = false,
	opts = {
		ensure_installed = { "lua_ls", "rust_analyzer", "glsl_analyzer", "basedpyright", "black", "clang" },
		automatic_installation = true,
	},
}
