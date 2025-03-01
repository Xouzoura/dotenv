-- Debug
return {
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      -- new?
      dap.listeners.before.event_terminated.dapui_config = dapui.close
      dap.listeners.before.event_exited.dapui_config = dapui.close
    end,
  },
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
      vim.keymap.set("n", "<leader>dz", function()
        require("dap").close()
      end, { desc = "[d]Close/Stop" })
      vim.keymap.set("n", "<F2>", function()
        require("dap").terminate()
      end, { desc = "Terminate" })
      -- Continue
      vim.keymap.set("n", "<F4>", function()
        require("dap").step_over()
      end, { desc = "Step Over" })
      vim.keymap.set("n", "<F3>", function()
        require("dap").step_into()
      end, { desc = "Step Into" })
      vim.keymap.set("n", "<F12>", function()
        require("dap").step_out()
      end, { desc = "Step Out" })
      -- Commented-out since I see the persistent db
      -- vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end, {desc="Toggle Breakpoint"})
      vim.keymap.set("n", "<leader>dB", function()
        require("dap").set_breakpoint()
      end, { desc = "[d]Set Breakpoint" })
      vim.keymap.set("n", "<leader>dd", function()
        require("dap").set_breakpoint(nil, nil, vim.fn.input "Log point message: ")
      end, { desc = "[d]Log Point" })
      vim.keymap.set("n", "<leader>de", ":edit .vscode/launch.json<CR>", { desc = "Step Over" })
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = false,
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("nvim-dap-virtual-text").setup {
        virt_text_pos = "eol",
      }
      vim.keymap.set("n", "<leader>duv", "<cmd>DapVirtualTextToggle<CR>", { desc = "[d]Toggle Virtual Text" })
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    lazy = false,
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
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
      dap_python.setup(python_path)
      dap_python.default_port = 38000
    end,
    keys = {
      { "<leader>dui", "<cmd>lua require( 'dapui' ).toggle()<CR>", desc = "[d]Toggle DAP UI" },
      { "<leader>dur", "<cmd>lua require( 'dapui' ).open({reset=true})<CR>", desc = "[d]Reset DAP UI" },
      { "<leader>dx", "<cmd>lua require( 'dapui' ).close()<CR>", desc = "[d]Close DAP UI" },
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
}
