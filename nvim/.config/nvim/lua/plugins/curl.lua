return {
  "oysandvik94/curl.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  lazy=false,
  config = function()
    require("curl").setup({})
  end
}
