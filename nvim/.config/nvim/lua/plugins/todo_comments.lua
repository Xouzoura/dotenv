return {
  -- With the <space>TD(L+R) you can see the todo list. Options are:
  -- TODO:
  -- FIX:
  -- HACK:
  -- WARNING:
  -- NOTE:
  -- PERF:
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>tq", "<cmd>TodoLocList<cr>", desc = "<ToDo> Loclist" },
    { "<leader>et", "<cmd>TodoQuickFix<cr>", desc = "<ToDo> Quickfix" },
    { "<leader>ftd", "<cmd>TodoFzfLua<cr>", desc = "<ToDo> FzfLua" },
  },
  opts = {},
}
