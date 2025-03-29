return {
  "oskarrrrrrr/symbols.nvim",
  lazy = false,
  config = function()
    local r = require "symbols.recipes"
    require("symbols").setup(r.DefaultFilters, r.AsciiSymbols, {
      -- custom settings here
      -- e.g. hide_cursor = false
      open_direction = "try-right",
    })
    vim.keymap.set("n", "<leader>a", "<cmd> SymbolsToggle<CR>")
    -- vim.keymap.set("n", ",S", "<cmd> SymbolsClose<CR>")
  end,
}
