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
    { "<leader>tl", "<cmd>TodoLocList<cr>", desc = "<ToDo> Loclist" },
    { "<leader>tq", "<cmd>TodoQuickFix<cr>", desc = "<ToDo> Quickfix" },
    { "<leader>ftd", "<cmd>TodoFzfLua<cr>", desc = "<ToDo> FzfLua" },
  },
  opts = {},
}
