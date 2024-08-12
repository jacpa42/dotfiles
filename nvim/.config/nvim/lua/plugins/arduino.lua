return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    setup = {
      arduino_language_server = function(_, opts)
        require("lspconfig").arduino_language_server.setup({
          server = opts,
          cmd = {
            "arduino-language-server",
            "-cli-config",
            "~/.arduino15/arduino-cli.yaml",
            "-fqbn",
            "arduino:renesas_uno:unor4wifi",
          },
        })
        return true
      end,
    },
  },
}
