return {
  "folke/trouble.nvim",
  opts = {},
  cmd = "Trouble",
  keys = {
    {
      "<leader>x;",
      "<cmd>Trouble diagnostics toggle focus=true win.type = split win.position=right<cr>",
      desc = "(Trouble) All Buffer Diagnostics All Right side",
    },
    {
      "<leader>x:",
      "<cmd>Trouble diagnostics toggle filter.buf=0 win.type = split win.position=right<cr>",
      desc = "(Trouble) Current Buffer Diagnostics All Right side",
    },
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "(Trouble) Buffer Diagnostics All Down side",
    },
  },
}
