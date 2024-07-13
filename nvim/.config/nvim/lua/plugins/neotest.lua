-- {
--   "nvim-neotest/neotest",
--   dependencies = {
--     "nvim-neotest/nvim-nio",
--     "nvim-lua/plenary.nvim",
--     "antoinemadec/FixCursorHold.nvim",
--     "nvim-treesitter/nvim-treesitter"
--     },
--   function()
--     require()
--   end
-- }
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/neotest-python",
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  lazy = false,
  cmd = "Neotest",
  config = function()
    local neotest = require "neotest"
    neotest.setup {
      adapters = {
        require "neotest-python" {
          dap = { justMyCode = false },

          python = function()
            local poetry_venv = vim.fn.getcwd() .. "/.venv/bin/python"
            if vim.fn.filereadable(poetry_venv) == 1 then
              return poetry_venv
            end
            raise "No virtualenv found"
          end,
        },
      },
    }
    -- Function to run all tests
    local function run_all_tests()
      neotest.run.run(vim.fn.getcwd())
    end

    -- Function to run tests with custom arguments
    local function run_custom_tests()
      vim.ui.input({ prompt = "Enter pytest arguments: " }, function(input)
        if input then
          neotest.run.run {
            vim.fn.getcwd(),
            extra_args = vim.split(input, " "),
          }
        end
      end)
    end
    -- Keymaps (will all start from <leader>t)
    vim.keymap.set("n", "<leader>tt", function()
      neotest.run.run()
    end, { desc = "Run nearest test" })

    vim.keymap.set("n", "<leader>tf", function()
      neotest.run.run(vim.fn.expand "%")
    end, { desc = "Run current file" })

    vim.keymap.set("n", "<leader>td", function()
      neotest.run.run { strategy = "dap" }
    end, { desc = "Debug" })

    vim.keymap.set("n", "<leader>ta", run_all_tests, { desc = "Run all tests" })

    vim.keymap.set("n", "<leader>tc", run_custom_tests, { desc = "Run tests with custom args" })

    vim.keymap.set("n", "<leader>ts", function()
      neotest.summary.toggle()
    end, { desc = "Toggle test summary" })

    vim.keymap.set("n", "<leader>to", function()
      neotest.output.open { enter = true }
    end, { desc = "Open test output" })
  end,
}
