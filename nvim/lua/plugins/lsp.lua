return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "clangd",
        "cpplint",
        "rust-analyzer",
        "markdownlint-cli2",
        "marksman",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "rust",
        "wgsl",
        "python",
        "yaml",
        "c",
        "cpp",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },

      setup = {
        rust_analyzer = function()
          return true
        end,
      },
    },
  },
}
