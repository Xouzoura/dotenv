local docker_running = false
return {
  "stevearc/overseer.nvim",
  -- "",
  -- tag = "v1.6.0", -- bro said breaking changes after that
  tag = "v2.1.0", -- bro said breaking changes after that
  -- #TODO: try 2.1.0
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
        vim.cmd "OverseerRestartLast"
      end,
      desc = "(Overseer) Rerun Last",
    },
    {
      "<leader>ej",
      mode = { "n" },
      function()
        local overseer = require "overseer"
        if docker_running then
          overseer.run_task { name = "docker compose down" }
          docker_running = false
        else
          overseer.run_task { name = "docker compose up" }
          docker_running = true
        end
      end,
      desc = "(Overseer) Docker compose toggle",
    },
    {
      "<leader>ey",
      mode = { "n" },
      function()
        vim.cmd "OverseerToggleUv"
      end,
      desc = "(Overseer) toggle uv",
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
    vim.api.nvim_create_user_command("OverseerToggleUv", function()
      local overseer = require "overseer"

      for _, task in ipairs(overseer.list_tasks()) do
        if string.find(task.name or "", "uv run", 1, true) then
          if task:is_running() then
            print("STOPPING ", task.name)
            overseer.run_action(task, "stop")
          else
            print("RESTARTING ", task.name)
            overseer.run_action(task, "restart")
          end
          return
        end
      end

      overseer.run_task { name = "uv run" }
    end, {})
    require("overseer").register_template(require("configs.overseer").docker_up)
    require("overseer").register_template(require("configs.overseer").docker_down)
    require("overseer").register_template(require("configs.overseer").uv_run)
  end,
}
