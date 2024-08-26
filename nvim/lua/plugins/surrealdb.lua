return {
  "dariuscorvus/tree-sitter-surrealdb.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("tree-sitter-surrealdb").setup()
  end,
}
