return {
  -- Easy replacer for the word under the cursor
  -- space + R + options to replace within a file/buffer
  "roobert/search-replace.nvim",
  lazy = false,
  config = function()
    require("search-replace").setup {
      -- optionally override defaults
      default_replace_single_buffer_options = "gcI",
      default_replace_multi_buffer_options = "egcI",
    }
    local map = vim.keymap.set
    -- Replace
    map(
      "v",
      "<leader>rw",
      "<CMD>SearchReplaceSingleBufferVisualSelection<CR>",
      { desc = "<Replace>Word", noremap = true, silent = true }
    )
    map(
      "n",
      "<leader>rx",
      "<CMD>SearchReplaceSingleBufferOpen<CR>",
      { desc = "<Replace>Formula", noremap = true, silent = true }
    )
    map(
      "n",
      "<leader>rw",
      "<CMD>SearchReplaceSingleBufferCWord<CR>",
      { desc = "<Replace>word", noremap = true, silent = true }
    )
    map(
      "n",
      "<leader>rW",
      "<CMD>SearchReplaceSingleBufferCWORD<CR>",
      { desc = "<Replace>[W]ord", noremap = true, silent = true }
    )
    map(
      "n",
      "<leader>rE",
      "<CMD>SearchReplaceSingleBufferCExpr<CR>",
      { desc = "<Replace>Expression", noremap = true, silent = true }
    )
  end,
}
