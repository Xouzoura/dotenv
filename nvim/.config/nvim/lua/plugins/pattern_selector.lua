return {
  "Xouzoura/pattern-selector",
  lazy = false,
  branch = "master",
  config = function(_, opts)
    require("pattern_selector").setup(opts)
    -- Set a keymap to call the pattern selector function
    vim.api.nvim_set_keymap(
      "n",
      "<leader>cu",
      ":lua require('pattern_selector').FindAndSelectPattern()<CR>",
      { noremap = true, silent = true, desc = "Find and select pattern" }
    )
    -- Set a keymap to call the replace with function

    vim.api.nvim_set_keymap(
      "n",
      "<leader>cr",
      ":lua require('pattern_selector').ReplaceWithClipboard()<CR>",
      { noremap = true, silent = true, desc = "Replace with clipboard" }
    )
  end,
}
