return {
  'saghen/blink.cmp',
  dependencies = 'rafamadriz/friendly-snippets',
  version = '*',
  build = 'cargo build --release',
  opts_extend = { "sources.default" },

  opts = {
    keymap = {
      -- set to 'none' to disable the 'default' preset
      preset = 'default',

      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<Cr>'] = { 'select_and_accept', 'fallback' },
      ['<Esc>'] = { 'cancel', 'fallback' },
      ['<S-k>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<Tab>'] = {
        function(cmp)
          if cmp.snippet_active() then return cmp.accept()
          else return cmp.select_and_accept() end
        end,
        'snippet_forward',
        'fallback'
      },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
    },
    appearance = {
      use_nvim_cmp_as_default = true,
    },

    sources = {
      default = { 'lsp', 'path', 'snippets' },
      providers = {
        lsp = {
          name = 'LSP',
          module = 'blink.cmp.sources.lsp',
          enabled = true, -- Whether or not to enable the provider
          async = true, -- Whether we should wait for the provider to return before showing the completions
          timeout_ms = 1000, -- How long to wait for the provider to return before showing completions and treating it as asynchronous
          should_show_items = true, -- Whether or not to show the items
        }
      }
    },
  },
}
