return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/neotest-python",
    -- "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    -- "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "tpope/vim-dotenv",
    -- "ellisonleao/dotenv.nvim",
  },
  lazy = false,
  cmd = "Neotest",
  config = function()
    local neotest = require "neotest"
    local function load_env(file)
      local env_vars = {}
      local file = io.open(file, "r")

      if file then
        for line in file:lines() do
          line = line:match "^%s*(.-)%s*$"
          if not line:match "^#" and line ~= "" then
            local key, value = line:match "^([%w_]+)=(.*)$"
            if key and value then
              env_vars[key] = value
            end
          end
        end
        file:close()
      end

      return env_vars
    end

    local env_vars = load_env ".env"

    for k, v in pairs(env_vars) do
      vim.fn.setenv(k, v)
    end
    neotest.setup {
      adapters = {
        require "neotest-python" {
          dap = { justMyCode = false },
          runner = "pytest",
          python = ".venv/bin/python",
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
    end, { desc = "[t]Run nearest test" })

    vim.keymap.set("n", "<leader>tf", function()
      neotest.run.run(vim.fn.expand "%")
    end, { desc = "[t]Run current file" })

    vim.keymap.set("n", "<leader>td", function()
      neotest.run.run { strategy = "dap" }
    end, { desc = "[t]Debug" })

    vim.keymap.set("n", "<leader>ta", run_all_tests, { desc = "[t]Run all tests" })

    vim.keymap.set("n", "<leader>tc", run_custom_tests, { desc = "[t]Run tests with custom args" })

    vim.keymap.set("n", "<leader>ts", function()
      neotest.summary.toggle()
    end, { desc = "[t]Toggle test summary" })

    vim.keymap.set("n", "<leader>to", function()
      neotest.output.open { enter = true }
    end, { desc = "Open test output" })
  end,
}
