---@diagnostic disable: undefined-global
-- Debug
return {
  -- REMEMBER YOU NEED DEBUGPY INSTALLED IF YOU USE IT WITH .venv
  -- uv add debugpy
  -- DAP_FULL_LAYOUT=1
  -- {
  --   "rcarriga/nvim-dap-ui",
  --   lazy = true, -- lazy load
  --   dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  --   keys = {
  --     {
  --       "<leader>d;",
  --       function()
  --         require("dapui").toggle()
  --       end,
  --       desc = "[d]Toggle DAP UI",
  --     },
  --     {
  --       "<leader>du",
  --       function()
  --         require("dapui").open { reset = true }
  --       end,
  --       desc = "[d]Reset DAP UI",
  --     },
  --     {
  --       "<leader>da",
  --       function()
  --         require("dapui").float_element "scopes"
  --       end,
  --       desc = "[d] Float scopes",
  --     },
  --     {
  --       "<leader>ds",
  --       function()
  --         require("dapui").float_element "stacks"
  --       end,
  --       desc = "[d] Float stacks",
  --     },
  --     {
  --       "<leader>dw",
  --       function()
  --         require("dapui").float_element "watches"
  --       end,
  --       desc = "[d] Float watches",
  --     },
  --     {
  --       "<leader>d0",
  --       function()
  --         for _, win in ipairs(vim.api.nvim_list_wins()) do
  --           local buf = vim.api.nvim_win_get_buf(win)
  --           local name = vim.api.nvim_buf_get_name(buf)
  --           if not name:match "dap" then
  --             vim.api.nvim_set_current_win(win)
  --             return
  --           end
  --         end
  --         vim.notify("DAP main not found", vim.log.levels.WARN)
  --       end,
  --       desc = "[d] Focus DAP main",
  --     },
  --     {
  --       "<leader>d1",
  --       function()
  --         for _, win in ipairs(vim.api.nvim_list_wins()) do
  --           local buf = vim.api.nvim_win_get_buf(win)
  --           if vim.api.nvim_buf_get_name(buf):match "%[dap%-repl" then
  --             vim.api.nvim_set_current_win(win)
  --             return
  --           end
  --         end
  --         vim.notify("DAP REPL not found", vim.log.levels.WARN)
  --       end,
  --       desc = "[d] Focus DAP REPL",
  --     },
  --     {
  --       "<leader>d2",
  --       function()
  --         for _, win in ipairs(vim.api.nvim_list_wins()) do
  --           local buf = vim.api.nvim_win_get_buf(win)
  --           if vim.api.nvim_buf_get_name(buf):match "Console" or vim.api.nvim_buf_get_name(buf):match "terminal" then
  --             vim.api.nvim_set_current_win(win)
  --             return
  --           end
  --         end
  --         vim.notify("DAP Console not found", vim.log.levels.WARN)
  --       end,
  --       desc = "[d] Focus stdout",
  --     },
  --     {
  --       "<leader>d3",
  --       function()
  --         for _, win in ipairs(vim.api.nvim_list_wins()) do
  --           local buf = vim.api.nvim_win_get_buf(win)
  --           if vim.api.nvim_buf_get_name(buf):match "Watches" then
  --             vim.api.nvim_set_current_win(win)
  --             return
  --           end
  --         end
  --         vim.notify("DAP Watches not found", vim.log.levels.WARN)
  --       end,
  --       desc = "[d] Focus watches",
  --     },
  --     {
  --       "<leader>d4",
  --       function()
  --         for _, win in ipairs(vim.api.nvim_list_wins()) do
  --           local buf = vim.api.nvim_win_get_buf(win)
  --           if vim.api.nvim_buf_get_name(buf):match "Breakpoints" then
  --             vim.api.nvim_set_current_win(win)
  --             return
  --           end
  --         end
  --         vim.notify("DAP Breakpoints not found", vim.log.levels.WARN)
  --       end,
  --       desc = "[d] Focus breakpoints",
  --     },
  --   },
  --   config = function()
  --     local dap = require "dap"
  --     local dapui = require "dapui"
  --     local enable_full_layout = os.getenv "DAP_FULL_LAYOUT" == "1"
  --
  --     local _layouts = {
  --       {
  --         elements = { { id = "repl", size = 1 } },
  --         position = "bottom",
  --         size = 14,
  --       },
  --       {
  --         elements = { { id = "console", size = 1 } },
  --         position = "bottom",
  --         size = 20,
  --       },
  --     }
  --     if enable_full_layout then
  --       table.insert(_layouts, 1, {
  --         elements = {
  --           { id = "scopes", size = 0.4 },
  --           { id = "watches", size = 0.2 },
  --           { id = "stacks", size = 0.2 },
  --           { id = "breakpoints", size = 0.2 },
  --         },
  --         position = "left",
  --         size = 30,
  --       })
  --     end
  --     dapui.setup { layouts = _layouts }
  --
  --     dap.listeners.after.event_initialized["dapui_config"] = function()
  --       dapui.open()
  --     end
  --     dap.listeners.before.event_terminated.dapui_config = dapui.close
  --     dap.listeners.before.event_exited.dapui_config = dapui.close
  --   end,
  -- },
  {
    "mfussenegger/nvim-dap",
    config = function(_, opts)
      vim.fn.sign_define(
        "DapBreakpoint",
        { text = "🔴", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
      )

      vim.keymap.set("n", "<F5>", function()
        require("dap").continue()
      end, { desc = "[d]Continue" })
      vim.keymap.set("n", "<F6>", function()
        require("dap").run_last()
      end, { desc = "[d]Run Last" })
      vim.keymap.set("n", "<F9>", function()
        require("dap").restart()
      end, { desc = "[d]Restart" })
      -- vim.keymap.set("n", "<leader>dz", function()
      --   require("dap").close()
      -- end, { desc = "[d]Close/Stop" })
      vim.keymap.set("n", "<F2>", function()
        require("dap").terminate()
      end, { desc = "Terminate" })
      -- Continue
      vim.keymap.set("n", "<F10>", function()
        require("dap").step_over()
      end, { desc = "Step Over" })
      --
      vim.keymap.set("n", "<F11>", function()
        require("dap").step_into()
      end, { desc = "Step Into" })
      --
      vim.keymap.set("n", "<F12>", function()
        require("dap").step_out()
      end, { desc = "Step Out" })
      --
      vim.keymap.set("n", "<leader>dB", function()
        require("dap").set_breakpoint()
      end, { desc = "[d]Set (non-persistent) Breakpoint" })
      vim.keymap.set("n", "<leader>dR", ":edit .vscode/launch.json<CR>", { desc = "[d] Open launch.json" })
    end,
  },
  -- {
  --   "theHamsta/nvim-dap-virtual-text",
  --   -- lazy = false,
  --   dependencies = {
  --     "mfussenegger/nvim-dap",
  --     "rcarriga/nvim-dap-ui",
  --   },
  --   keys = {
  --     { "<leader>dv", "<cmd>DapVirtualTextToggle<CR>", desc = "[d] Toggle text UI" },
  --   },
  --   config = function()
  --     require("nvim-dap-virtual-text").setup {
  --       virt_text_pos = "eol",
  --     }
  --   end,
  -- },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    -- lazy = false,
    dependencies = {
      "mfussenegger/nvim-dap",
      -- "rcarriga/nvim-dap-ui",
    },
    config = function(_, opts)
      local function get_python_path()
        -- Use the currently active virtual environment's Python binary
        local venv_path = vim.fn.getcwd() .. "/.venv/bin/python"

        if vim.fn.filereadable(venv_path) == 1 then
          return venv_path
        else
          return vim.fn.expand "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
        end
      end

      local python_path = get_python_path()
      local dap_python = require "dap-python"
      local extras = require "extras"
      extras.add_env_values_to_buffer()
      dap_python.setup(python_path)
      dap_python.default_port = 38000
    end,
    keys = {
      -- { "<leader>d;", "<cmd>lua require( 'dapui' ).toggle()<CR>", desc = "[d]Toggle DAP UI" },
      -- { "<leader>du", "<cmd>lua require( 'dapui' ).open({reset=true})<CR>", desc = "[d]Reset DAP UI" },
    },
  },
  {
    "Weissle/persistent-breakpoints.nvim",
    config = function()
      require("persistent-breakpoints").setup {
        load_breakpoints_event = { "BufReadPost" },
        -- You can add other options here as needed
      }
    end,
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    event = "VeryLazy", -- or you could use "BufReadPre" if you want it loaded earlier
    keys = {
      {
        "<leader>db",
        function()
          require("persistent-breakpoints.api").toggle_breakpoint()
        end,
        desc = "[d]Toggle Breakpoint (Persistent)",
      },
      {
        "<leader>dc",
        function()
          require("persistent-breakpoints.api").clear_all_breakpoints()
        end,
        desc = "[d]Clear All Breakpoints",
      },
    },
  },
  {
    "igorlfs/nvim-dap-view",
    dependencies = { "mfussenegger/nvim-dap" },
    lazy = true,

    keys = {
      {
        "<leader>d;",
        function()
          require("dap-view").toggle()
        end,
        desc = "[d] Toggle DAP View",
      },
      {
        "<leader>du",
        function()
          require("dap-view").open()
        end,
        desc = "[d] Open DAP View",
      },
      {
        "<leader>da",
        function()
          require("dap-view").hover()
        end,
        desc = "[d] Hover variable",
      },
      {
        "<leader>dw",
        function()
          require("dap-view").add_expr()
        end,
        desc = "[d] Add watch",
      },

      -- Focus individual views
      {
        "<leader>dS",
        function()
          require("dap-view").jump_to_view "scopes"
        end,
        desc = "[d] Focus scopes",
      },
      {
        "<leader>dT",
        function()
          require("dap-view").jump_to_view "threads"
        end,
        desc = "[d] Focus threads",
      },
      {
        "<leader>dC",
        function()
          require("dap-view").jump_to_view "console"
        end,
        desc = "[d] Focus console",
      },
      {
        "<leader>dW",
        function()
          require("dap-view").jump_to_view "watches"
        end,
        desc = "[d] Focus watches",
      },
      {
        "<leader>d4",
        function()
          require("dap-view").jump_to_view "breakpoints"
        end,
        desc = "[d] Focus breakpoints",
      },
      {
        "<leader>dR",
        function()
          require("dap-view").jump_to_view "repl"
        end,
        desc = "[d] Focus REPL",
      },
      {
        "<leader>dE",
        function()
          require("dap-view").jump_to_view "exceptions"
        end,
        desc = "[d] Focus exceptions",
      },
      {
        "<leader>dv",
        function()
          require("dap-view").virtual_text_toggle()
        end,
        desc = "[d] Toggle text UI",
      },
    },

    opts = {
      -- Open when a debugging session starts and close when all sessions end.
      auto_toggle = true,

      -- Reopen the view when switching tabs.
      follow_tab = true,

      winbar = {
        show = true,
        sections = {
          "scopes",
          "watches",
          "threads",
          "breakpoints",
          "exceptions",
          "repl",
        },
        default_section = "scopes",
        show_keymap_hints = true,
      },
      virtual_text = {
        enabled = true, -- Control with `DapViewVirtualTextToggle`
        position = "eol", -- Supported options include "inline", "eol", and "eol_right_align"
      },
      windows = {
        size = 0.25,
        position = "below",
        terminal = {
          hide = true,
        },
      },
    },
  },
}

--- .vscode/launch.json example
--[=====[
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Python: Test (-m new)",
      "type": "python",
      "request": "launch",
      "module": "pytest",
      "args": [
        "-s",
        "-m new"
      ],
      "console": "integratedTerminal",
      "justMyCode": true,
      "python": "${workspaceFolder}/.venv/bin/python",
      "env": {
        "PYTHONPATH": "${workspaceFolder}"
      },
      "cwd": "${workspaceFolder}",
      "envFile": "${workspaceFolder}/.env"
    },
    {
      "name": "Python: Test ai-tools request",
      "type": "python",
      "request": "launch",
      "program": "${workspaceFolder}/src/services.py",
      "args": [
        "--ai_emb",
        "--v"
      ],
      "console": "integratedTerminal",
      "justMyCode": true,
      "python": "${workspaceFolder}/.venv/bin/python",
      "env": {
        "PYTHONPATH": "${workspaceFolder}"
      },
      "cwd": "${workspaceFolder}",
      "envFile": "${workspaceFolder}/.env"
    },
    {
      "name": "Python: Main debug",
      "type": "python",
      "request": "launch",
      "module": "uvicorn",
      "args": [
        "app.main:app",
        "--host",
        "0.0.0.0",
        "--port",
        "8000",
        "--reload",
        "--log-level",
        "debug"
      ],
      "console": "integratedTerminal",
      "justMyCode": true,
      "python": "${workspaceFolder}/.venv/bin/python",
      "env": {
        "PYTHONPATH": "${workspaceFolder}"
      },
      "cwd": "${workspaceFolder}/src",
      "envFile": "${workspaceFolder}/.env"
    }
  ]
}
--]=====]
