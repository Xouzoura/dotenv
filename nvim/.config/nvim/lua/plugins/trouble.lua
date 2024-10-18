return {
  "folke/trouble.nvim",
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    {
      "<leader>xxd",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "(Trouble) Buffer Diagnostics All Down side",
    },
    {
      "<leader>xxr",
      "<cmd>Trouble diagnostics toggle win.type = split win.position=right<cr>",
      desc = "(Trouble) Buffer Diagnostics All Right side",
    },
    {
      "<leader>xbd",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "(Trouble) Buffer Diagnostics Buffer [D]",
    },
    {
      "<leader>xbr",
      "<cmd>Trouble diagnostics toggle filter.buf=0 win.type = split win.position=right<cr>",
      desc = "(Trouble) Buffer Diagnostics Buffer [R]",
    },
    {
      "<leader>df", -- Might need something else since <leader>d(~) is used by debug
      "<cmd>lua vim.diagnostic.open_float()<cr>",
      desc = "Diagnostic error float open",
    },
    -- Currently dont need them
    -- {
    --   "<leader>xl",
    --   "<cmd>Trouble loclist toggle<cr>",
    --   desc = "Location List (Trouble)",
    -- },
    -- {
    --   "<leader>xq",
    --   "<cmd>Trouble qflist toggle<cr>",
    --   desc = "Quickfix List (Trouble)",
    -- },
    -- {
    --   "<leader>xj",
    --   "<cmd>Trouble symbols toggle focus=false<cr>",
    --   desc = "Symbols (Trouble)",
    -- },
    -- {
    --   "<leader>xd",
    --   "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
    --   desc = "LSP Definitions / references / ... (Trouble)",
    -- },
  },
}
