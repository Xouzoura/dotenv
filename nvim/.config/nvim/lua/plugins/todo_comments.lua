return {
  -- With the <space>TD(L+R) you can see the todo list. Options are:
  -- TODO:
  -- FIX:
  -- HACK:
  -- WARNING:
  -- NOTE:
  -- PERF:
  "folke/todo-comments.nvim",
  -- enabled = false, -- haven't used it in a while
  lazy = false,
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>tq", "<cmd>TodoLocList<cr>", desc = "<ToDo> Loclist" },
    { "<leader>et", "<cmd>TodoQuickfix<cr>", desc = "<ToDo> Quickfix" },
    { "<leader>ftd", "<cmd>TodoFzfLua<cr>", desc = "<ToDo> FzfLua" },
  },
  opts = {},
}
