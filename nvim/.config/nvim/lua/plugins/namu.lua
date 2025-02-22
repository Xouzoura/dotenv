return {
  "bassamsdata/namu.nvim",
  lazy = false,
  config = function()
    require("namu").setup {
      namu_symbols = {
        enable = true,
        options = {
          display = {
            mode = "icon",
          },
        }, -- here you can configure namu
      },
      ui_select = { enable = false }, -- vim.ui.select() wrapper
    }
    local namu = require "namu.namu_symbols"
    vim.keymap.set("n", "<leader>ss", namu.show, {
      desc = "Jump to LSP symbol",
      silent = true,
    })
  end,
}
