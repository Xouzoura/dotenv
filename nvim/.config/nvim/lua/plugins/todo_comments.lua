return {
  -- With the <space>TD(L+R) you can see the todo list. Options are:
  -- TODO:
  -- FIX:
  -- HACK:
  -- WARNING:
  -- NOTE:
  -- PERF:
  "folke/todo-comments.nvim",
  lazy = false,
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>TDL", "<cmd>TodoLocList<cr>", desc = "To Do List" },
    { "<leader>TDT", "<cmd>TodoTelescope<cr>", desc = "To Do Telescope" },
  },
  opts = {},
}
