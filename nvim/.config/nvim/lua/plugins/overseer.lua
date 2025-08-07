return {
  "stevearc/overseer.nvim",
  opts = {},
  -- lazy = false,
  keys = {
    {
      "<leader>er",
      mode = { "n" },
      function()
        vim.cmd "OverseerRun"
      end,
      desc = "(Overseer) Run",
    },
    {
      "<leader>e;",
      mode = { "n" },
      function()
        vim.cmd "OverseerToggle"
      end,
      desc = "(Overseer) Toggle",
    },
    {
      "<leader>e:",
      mode = { "n" },
      function()
        vim.cmd "OverseerToggle!"
      end,
      desc = "(Overseer) Toggle!",
    },
  },
}
