return {
  -- Highlight the arguments of the function in a specific color to know that it is provided.
  "m-demare/hlargs.nvim",
  lazy = false,
  config = function()
    require("hlargs").setup()
  end,
}
