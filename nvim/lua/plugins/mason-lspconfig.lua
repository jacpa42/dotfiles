return {
	"williamboman/mason.nvim",
	dependencies = "neovim/nvim-lspconfig",
	lazy = false,
	opts = {
 
		ensure_installed = { "basedpyright", "clangd","clang-format", "css-lsp", "glsl_analyzer", "html-lsp", "hyprls", "lua_ls", "marksman", "rust_analyzer", "taplo", "zls"},
		automatic_installation = true,
	},
}

