return {
  -- curl alternative using the .hurl file extension, expecting secrets in the vars.env file.
  "jellydn/hurl.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  ft = "hurl",
  opts = {
    -- Show debugging info
    debug = false,
    -- Show notification on run
    show_notification = false,
    -- Show response in popup or split
    mode = "split",
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
    { "<leader>te", "<cmd>HurlRunnerToEntry<CR>", desc = "(Hurl) Run Api request to entry" },
    { "<leader>cm", "<cmd>HurlToggleMode<CR>", desc = "(Hurl) Toggle Mode" },
    { "<leader>cv", "<cmd>HurlVerbose<CR>", desc = "(Hurl) Run Api in verbose mode" },
    -- Run Hurl request in visual mode
    { "<leader>c", ":HurlRunner<CR>", desc = "(Hurl) Visual Runner", mode = "v" },
  },
}
