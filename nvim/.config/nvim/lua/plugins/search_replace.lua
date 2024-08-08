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
    local opts = {}
    -- Replace
    map("v", "<C-r>", "<CMD>SearchReplaceSingleBufferVisualSelection<CR>", opts)
    map("v", "<C-s>", "<CMD>SearchReplaceWithinVisualSelection<CR>", opts)
    map("v", "<C-b>", "<CMD>SearchReplaceWithinVisualSelectionCWord<CR>", opts)

    map("n", "<leader>rs", "<CMD>SearchReplaceSingleBufferSelections<CR>", opts)
    map("n", "<leader>ro", "<CMD>SearchReplaceSingleBufferOpen<CR>", opts)
    map("n", "<leader>rw", "<CMD>SearchReplaceSingleBufferCWord<CR>", opts)
    map("n", "<leader>rW", "<CMD>SearchReplaceSingleBufferCWORD<CR>", opts)
    map("n", "<leader>re", "<CMD>SearchReplaceSingleBufferCExpr<CR>", opts)
    map("n", "<leader>rf", "<CMD>SearchReplaceSingleBufferCFile<CR>", opts)

    map("n", "<leader>rbs", "<CMD>SearchReplaceMultiBufferSelections<CR>", opts)
    map("n", "<leader>rbo", "<CMD>SearchReplaceMultiBufferOpen<CR>", opts)
    map("n", "<leader>rbw", "<CMD>SearchReplaceMultiBufferCWord<CR>", opts)
    map("n", "<leader>rbW", "<CMD>SearchReplaceMultiBufferCWORD<CR>", opts)
    map("n", "<leader>rbe", "<CMD>SearchReplaceMultiBufferCExpr<CR>", opts)
    map("n", "<leader>rbf", "<CMD>SearchReplaceMultiBufferCFile<CR>", opts)
  end,
}
