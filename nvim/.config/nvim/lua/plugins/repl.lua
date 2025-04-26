return {
  "pappasam/nvim-repl",
  keys = {
    -- { "<Leader>r", "<cmd>Repl<cr>", mode = "n", desc = "<Repl> Create" },
    { "<Leader>r.", "<cmd>ReplToggle<cr>", mode = "n", desc = "<Repl> Toggle" },
    { "<Leader>rq", "<cmd>ReplClear<cr>", mode = "n", desc = "<Repl> Clear" },
    { "<Leader>rs", "<Plug>(ReplSendCell)", mode = "n", desc = "<Repl> Send Cell" },
    { "<Leader>rl", "<Plug>(ReplSendLine)", mode = "n", desc = "<Repl> Send Line" },
    { "<Leader>rs", "<Plug>(ReplSendVisual)", mode = "x", desc = "<Repl> Send Visual Selection" },
  },
}
