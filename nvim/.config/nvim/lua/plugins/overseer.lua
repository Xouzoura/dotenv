return {
  "stevearc/overseer.nvim",
  -- "",
  tag = "v1.6.0", -- bro said breaking changes after
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
    {
      "<leader>ek",
      mode = { "n" },
      function()
        vim.cmd "OverseerRestartLast" -- this is part of the config below
      end,
      desc = "(Overseer) Rerun Last",
    },
  },
  config = function(_, opts)
    require("overseer").setup(opts)
    vim.api.nvim_create_user_command("OverseerRestartLast", function()
      local overseer = require "overseer"
      local tasks = overseer.list_tasks { recent_first = true }
      if vim.tbl_isempty(tasks) then
        vim.notify("No tasks found", vim.log.levels.WARN)
      else
        overseer.run_action(tasks[1], "restart")
      end
    end, {})
  end,
}
