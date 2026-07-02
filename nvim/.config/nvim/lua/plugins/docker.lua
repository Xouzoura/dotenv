return {
  "emrearmagan/dockyard.nvim",
  dependencies = {
    "akinsho/toggleterm.nvim", -- optional
  },
  cmd = { "Dockyard", "DockyardFloat" },
  keys = {
    {
      "<leader>ld",
      "<cmd>Dockyard<cr>",
      desc = "(fzf) Find Files",
    },
  },
  lazy = true,
  config = function()
    require("dockyard").setup {}
  end,
}
