require("config.remap")
require("config.lazy")
require("config.opts")

vim.filetype.add({
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})
