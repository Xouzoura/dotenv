return {
  -- Autocomplete suggestions for cmd
  "smolck/command-completion.nvim",
  lazy = false,
  config = function()
    require("command-completion").setup()
  end,
}
