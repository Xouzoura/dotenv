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
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function(_, opts)
      vim.fn.sign_define(
        "DapBreakpoint",
        { text = "🔴", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
      )

      vim.keymap.set("n", "<leader>dr", function()
        require("dap").continue()
      end, { desc = "Continue" })
      vim.keymap.set("n", "<leader>dl", function()
        require("dap").run_last()
      end, { desc = "Run Last" })
      vim.keymap.set("n", "<leader>dw", function()
        require("dap").restart()
      end, { desc = "Restart" })
      vim.keymap.set("n", "<leader>dt", function()
        require("dap").terminate()
      end, { desc = "Terminate" })
      -- Redone with the F keys
      vim.keymap.set("n", "<F5>", function()
        require("dap").continue()
      end, { desc = "Continue" })
      vim.keymap.set("n", "<F6>", function()
        require("dap").run_last()
      end, { desc = "Run Last" })
      vim.keymap.set("n", "<F9>", function()
        require("dap").restart()
      end, { desc = "Restart" })
      vim.keymap.set("n", "<F2>", function()
        require("dap").terminate()
      end, { desc = "Terminate" })
      -- Continue
      vim.keymap.set("n", "<F10>", function()
        require("dap").step_over()
      end, { desc = "Step Over" })
      vim.keymap.set("n", "<F11>", function()
        require("dap").step_into()
      end, { desc = "Step Into" })
      vim.keymap.set("n", "<F12>", function()
        require("dap").step_out()
      end, { desc = "Step Out" })
      -- Commented-out since I see the persistent db
      -- vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end, {desc="Toggle Breakpoint"})
      vim.keymap.set("n", "<Leader>dn", function()
        require("dap").toggle_breakpoint()
      end, { desc = "Toggle Breakpoint (Normal)" })
      vim.keymap.set("n", "<Leader>dB", function()
        require("dap").set_breakpoint()
      end, { desc = "Set Breakpoint" })
      vim.keymap.set("n", "<Leader>dd", function()
        require("dap").set_breakpoint(nil, nil, vim.fn.input "Log point message: ")
      end, { desc = "Log Point" })
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
      vim.keymap.set("n", "<leader>dv", "<cmd>DapVirtualTextToggle<CR>", { desc = "Toggle Virtual Text" })
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
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
      require("dap-python").setup(python_path)
    end,
    keys = {
      { "<leader>dui", "<cmd>lua require( 'dapui' ).toggle()<CR>", desc = "Toggle DAP UI" },
      { "<leader>dur", "<cmd>lua require( 'dapui' ).open({reset=true})<CR>", desc = "Reset DAP UI" },
      { "<leader>dx", "<cmd>lua require( 'dapui' ).close()<CR>", desc = "Toggle DAP UI" },
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
        desc = "Toggle Breakpoint (Persistent)",
      },
      {
        "<leader>dc",
        function()
          require("persistent-breakpoints.api").clear_all_breakpoints()
        end,
        desc = "Clear All Breakpoints",
      },
    },
  },
}
