return {
  "roobert/search-replace.nvim",
  lazy = true, -- only load on key press
  keys = {
    { "<leader>rw", "<CMD>SearchReplaceSingleBufferCWord<CR>", desc = "<Replace>word" },
    { "<leader>rW", "<CMD>SearchReplaceSingleBufferCWORD<CR>", desc = "<Replace>[W]ord" },
    { "<leader>rE", "<CMD>SearchReplaceSingleBufferCExpr<CR>", desc = "<Replace>Expression" },
    { "<leader>rx", "<CMD>SearchReplaceSingleBufferOpen<CR>", desc = "<Replace>Formula" },
    { "<leader>rw", "<CMD>SearchReplaceSingleBufferVisualSelection<CR>", mode = "v", desc = "<Replace>Word" },
  },
  config = function()
    require("search-replace").setup {
      default_replace_single_buffer_options = "gcI",
      default_replace_multi_buffer_options = "egcI",
    }
  end,
}
