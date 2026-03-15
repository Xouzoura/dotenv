return {
  "emrearmagan/dockyard.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "akinsho/toggleterm.nvim", -- optional
  },
  cmd = { "Dockyard", "DockyardFloat" },
  keys = {
    {
      "<leader>D;",
      "<cmd>Dockyard<cr>",
      desc = "(Docker) open",
    },
  },
  lazy = true,
  config = function()
    require("dockyard").setup {}
  end,
}
