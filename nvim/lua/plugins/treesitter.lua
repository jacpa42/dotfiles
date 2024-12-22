return {
  "nvim-treesitter/nvim-treesitter", 
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      ensure_installed = { "c", "lua", "rust", "zig", "python" },
      sync_install = false,
      auto_install = true,
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      indent = { enable = true },  
    }
  }
}
