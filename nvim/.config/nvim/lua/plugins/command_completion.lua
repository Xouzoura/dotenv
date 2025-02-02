return {
  -- Autocomplete suggestions for cmd when typing : in command mode
  "smolck/command-completion.nvim",
  lazy = false,
  config = function()
    require("command-completion").setup()
  end,
}
