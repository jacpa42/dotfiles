return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        wgsl_analyzer = {
          settings = {
            ["wgsl-analyzer"] = {},
          },
          handlers = {
            ["wgsl-analyzer/requestConfiguration"] = function()
              return {
                success = true,
                customImports = { _dummy_ = "dummy" },
                shaderDefs = {},
                trace = {
                  extension = false,
                  server = false,
                },
                inlayHints = {
                  enabled = true,
                  typeHints = true,
                  parameterHints = true,
                  structLayoutHints = true,
                  typeVerbosity = "inner",
                },
                diagnostics = {
                  typeErrors = true,
                  nagaParsingErrors = true,
                  nagaValidationErrors = true,
                  nagaVersion = "main",
                },
              }
            end,
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "wgsl" })
      end
    end,
  },
}
