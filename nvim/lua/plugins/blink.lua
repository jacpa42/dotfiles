return {
  'saghen/blink.cmp',
  dependencies = 'rafamadriz/friendly-snippets',
  version = '*',
  build = 'cargo build --release',
  opts_extend = { "sources.default" },


  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = 'default' },

    appearance = {
      use_nvim_cmp_as_default = true,
    },

    sources = {
      default = { 'lsp', 'path', 'snippets' },
    },
  },
}
