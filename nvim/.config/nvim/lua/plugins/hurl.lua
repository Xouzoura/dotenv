--- Hurl.nvim configuration
local builtin = require "telescope.builtin"

vim.keymap.set("n", "<leader>cf", function()
  builtin.find_files {
    prompt_title = "Find Hurl Files",
    cwd = vim.loop.cwd(), -- Use the current working directory
    find_command = { "rg", "--files", "--glob", "*.hurl" },
  }
end, { desc = "(hurl) Find .hurl files in project" })
vim.keymap.set("n", "<leader>cw", function()
  require("telescope.builtin").live_grep {
    prompt_title = "Grep Hurl Files",
    cwd = vim.loop.cwd(), -- Use the current working directory
    additional_args = function()
      return { "--glob", "*.hurl" }
    end,
  }
end, { desc = "(hurl) Live Grep in .hurl files" })
return {
  -- "jellydn/hurl.nvim",
  "Xouzoura/hurl.nvim",
  -- branch = "feature/show-body-query-params",
  branch = "main",
  -- dir = "/home/xouzoura/python/me/openai/hurl.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  ft = "hurl",
  opts = {
    debug = false,
    show_notification = false,
    mode = "split",
    url = {
      show = true,
      format_without_params = true,
      show_body_and_query = true,
    },
    -- header options from { "content-length", "content-type", "date", "server", "status" },
    headers = { "status" },
    -- Default formatter
    formatters = {
      json = { "jq" }, -- Make sure you have install jq in your system, e.g: brew install jq
      xml = {
        "tidy", -- Make sure you have installed tidy in your system, e.g: brew install tidy-html5
        "-xml",
        "-i",
        "-q",
      },
      html = {
        "prettier", -- Make sure you have install prettier in your system, e.g: npm install -g prettier
        "--parser",
        "html",
      },
    },
    -- Default mappings for the response popup or split views
    mappings = {
      close = "q", -- Close the response popup or split view
      next_panel = "<C-n>", -- Move to the next response popup window
      prev_panel = "<C-p>", -- Move to the previous response popup window
    },
    fixture_vars = {
      {
        name = "RAND_INT",
        callback = function()
          return math.random(1, 1000)
        end,
      },
      {
        name = "RAND_FLOAT",
        callback = function()
          local result = math.random() * 10
          return string.format("%.2f", result)
        end,
      },
      {
        name = "RAND_UUID4",
        callback = function()
          local function uuid()
            local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
            return string.gsub(template, "[xy]", function(c)
              local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
              return string.format("%x", v)
            end)
          end
          return uuid()
        end,
      },
    },
  },
  keys = {
    -- Run API request
    { "<leader>cA", "<cmd>HurlRunner<CR>", desc = "(Hurl) Run All requests" },
    { "<leader>ca", "<cmd>HurlRunnerAt<CR>", desc = "(Hurl) Run Api request" },
    -- { "<leader>cz", "<cmd>HurlRunnerToEntry<CR>", desc = "(Hurl) Run Api request to entry" },
    -- { "<leader>cm", "<cmd>HurlToggleMode<CR>", desc = "(Hurl) Toggle Mode" },
    -- { "<leader>cv", "<cmd>HurlVerbose<CR>", desc = "(Hurl) Run Api in verbose mode" },
    { "<leader>c[", "<cmd>HurlShowLastResponse<CR>", desc = "(Hurl) Show last response" },
    { "<leader>ck", "<cmd>HurlRerun<CR>", desc = "(Hurl) Rerun last command" },
    -- Run Hurl request in visual mode
    { "<leader>c", ":HurlRunner<CR>", desc = "(Hurl) Visual Runner", mode = "v" },
    -- General mappings
    { "<leader>ce", ":edit vars.env<CR>", desc = "(Hurl) Open vars.env file" },
    { "<leader>cj", ":edit .hurls/vars.hurl<CR>", desc = "(Hurl) Open vars.hurl file" },
  },
}
