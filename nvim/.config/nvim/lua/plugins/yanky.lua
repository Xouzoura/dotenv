return {
  "gbprod/yanky.nvim",
  opts = {
    ring = {
      history_length = 15,
      storage = "shada",
      sync_with_numbered_registers = true,
    },
    system_clipboard = {
      sync_with_ring = false, -- this is causing me issues with multiple nvim sessions open
      clipboard_register = nil, -- this is causing me issues with multiple nvim sessions open
    },
    highlight = {
      on_yank = false,
      on_put = false,
    },
    preserve_cursor_position = {
      enabled = true,
    },
  },
  keys = {
    { "y", "<Plug>(YankyYank)", mode = { "n", "x" } },
    { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" } },
    { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" } },
    { "<leader>pp", "<cmd>YankyRingHistory<cr>", desc = "Yanky Ring History" },
    {
      "<leader>ph",
      "<cmd>lua require('telescope').extensions.yank_history.yank_history({ initial_mode = 'normal' })<cr>",
      desc = "Yanky Paste History",
    },
    { "<leader>pc", "<cmd>YankyClearHistory<cr>", desc = "Clear Yank History" },
  },
  event = "BufReadPre",
}
