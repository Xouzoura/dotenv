return {
  -- NOTE: check if I actually use it.
  "gbprod/substitute.nvim",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  lazy = false,
  config = function()
    require("substitute").setup()
    vim.keymap.set("n", "x", require("substitute").operator, { noremap = true })
    vim.keymap.set("n", "xx", require("substitute").line, { noremap = true })
    vim.keymap.set("n", "X", require("substitute").eol, { noremap = true })
    vim.keymap.set("x", "x", require("substitute").visual, { noremap = true })
  end,
}
