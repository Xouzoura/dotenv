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
  end,
}
