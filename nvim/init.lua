require("config.lazy")
require("config.remap")
require("config.status")
require("config.autocmds")
require("config.lsp")
require("config.greeter")

vim.cmd.colorscheme("kanagawa-wave")
vim.cmd([[
    hi TelescopeBorder guibg=NONE
    hi FloatBorder guibg=NONE
    hi NormalFloat guibg=NONE
    hi FloatTitle guibg=NONE
    hi LineNr guibg=NONE
    hi DiagnosticSignInfo guibg=NONE
    hi DiagnosticSignWarn guibg=NONE
    hi DiagnosticSignError guibg=NONE
    hi DiagnosticSignHint guibg=NONE
    hi StatusLine guibg=NONe
]])
