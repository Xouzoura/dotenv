return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  config = function()
    require("markview").setup {
      preview = { enable = false },
    }
  end,
  keys = {
    {
      "<leader>md",
      mode = { "n" },
      "<CMD>Markview<CR>",
      desc = "(Overseer) Run",
    },
  },
}
