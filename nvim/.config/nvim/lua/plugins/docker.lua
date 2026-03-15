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
      desc = "(fzf) Find Files",
    },
  },
  lazy = true,
  config = function()
    require("dockyard").setup {}
  end,
}
