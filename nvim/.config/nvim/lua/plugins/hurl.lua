local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local previewers = require "telescope.previewers"
local conf = require("telescope.config").values
local action_state = require "telescope.actions.state"
local actions = require "telescope.actions"

local function parse_hurl_file(filepath)
  local requests = {}
  local current_request = {}
  local line_number = 0
  for line in io.lines(filepath) do
    line_number = line_number + 1
    line = line:gsub("^%s*(.-)%s*$", "%1")
    line = line:gsub("%s+", " ")
    local non_comment = string.find(line, "^[^#]")
    local matchcase = string.find(line, "^GET ")
      or string.find(line, "^POST ")
      or string.find(line, "^PUT ")
      or string.find(line, "^DELETE ")
      or string.find(line, "^PATCH ")
    if matchcase and non_comment then
      if #current_request > 0 then
        table.insert(requests, { content = table.concat(current_request, "\n"), line = current_request.line })
        current_request = {}
      end
      current_request.line = line_number
    end
    table.insert(current_request, line)
  end
  if #current_request > 0 then
    table.insert(requests, { content = table.concat(current_request, "\n"), line = current_request.line })
  end
  return requests
end

local function hurl_picker()
  local filepath = vim.fn.expand "%:p"
  if filepath == "" then
    print "Error: No file is currently open."
    return
  end

  local requests = parse_hurl_file(filepath)
  if #requests == 0 then
    print "Error: No valid HTTP requests found in the file."
    return
  end

  pickers
    .new({}, {
      prompt_title = "Hurl File Requests",
      finder = finders.new_table {
        results = requests,
        entry_maker = (function()
          local counter = 0
          return function(entry)
            counter = counter + 1
            local label = counter <= 96 and tostring(counter)
            local display = "[" .. label .. "] " .. (entry.content:match "^%u+ [^%s]+" or entry.content:sub(1, 50))
            local method = entry.content:match "^%u+" -- Extract the HTTP method
            -- local method, path = entry.content:match "^(%u+)%s+([^%s]+)"
            -- local display = string.format("[%s] %s %s", label, method, path)
            return {
              value = entry,
              display = display,
              ordinal = entry.content,
              line = entry.line,
              method = method,
              label = label,
            }
          end
        end)(),
      },

      sorter = conf.generic_sorter {
        discard_state = true,
        case_mode = "respect_case", -- Case-sensitive match
      },
      previewer = previewers.new_buffer_previewer {
        define_preview = function(self, entry, status)
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(entry.value.content, "\n"))
        end,
      },
      attach_mappings = function(prompt_bufnr, map)
        map("i", "<CR>", function()
          actions.close(prompt_bufnr)
          local selected_entry = action_state.get_selected_entry().value
          -- Ensure selected_entry.line is a valid number
          local line_number = tonumber(selected_entry.line) or 1
          vim.api.nvim_win_set_cursor(0, { line_number, 0 })
        end)

        -- Use normal mode mappings for direct label jumps to avoid interference with insert mode filtering
        for i, request in ipairs(requests) do
          local label = i <= 96 and tostring(i)
          map("n", label, function()
            actions.close(prompt_bufnr)
            local line_number = tonumber(request.line) or 1
            vim.api.nvim_win_set_cursor(0, { line_number, 0 })
          end)
        end

        return true
      end,
    })
    :find()
end

vim.api.nvim_create_user_command("HurlPickerTs", function()
  hurl_picker()
end, {})

-- Telescope key mapping
vim.api.nvim_set_keymap("n", "<leader>cs", ":HurlPickerTs<CR>", { noremap = true, silent = true })

return {
  -- "jellydn/hurl.nvim",
  "Xouzoura/hurl.nvim",
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
    url = {
      show = true,
      format_without_params = true,
    },
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
    { "<leader>cj", ":edit vars.hurl<CR>", desc = "(Hurl) Open vars.hurl file" },
    { "<leader>E", ":edit .env<CR>", desc = "Open .env file" },
    { "<leader>R", ":edit pyproject.toml<CR>", desc = "Open pyproject.toml file" },
  },
}
