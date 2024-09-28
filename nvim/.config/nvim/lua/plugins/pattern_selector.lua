return {
  "Xouzoura/pattern-selector",
  lazy = false,
  config = function(_, opts)
    require("pattern_selector").setup(opts)
    -- Set a keymap to call the pattern selector function
    vim.api.nvim_set_keymap(
      "n",
      "<leader>cu",
      ":lua require('pattern_selector').FindAndSelectPattern()<CR>",
      { noremap = true, silent = true }
    )
  end,
}
