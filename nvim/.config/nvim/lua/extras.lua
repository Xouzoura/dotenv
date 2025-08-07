---@diagnostic disable: undefined-global
local M = {}

function M.run_file()
  -- support for [lua, python, rust, go, bash]
  local filepath = vim.fn.expand "%:p"
  local extension = vim.fn.fnamemodify(filepath, ":e")

  if extension == "py" then
    -- Check for pyproject.toml to use poetry
    if vim.fn.filereadable(vim.fn.expand "pyproject.toml") == 1 then
      if vim.fn.filereadable(vim.fn.expand "uv.lock") == 1 then
        vim.cmd("!uv run " .. filepath)
      elseif vim.fn.filereadable(vim.fn.expand "poetry.lock") == 1 then
        vim.cmd("!poetry run python " .. filepath)
      else
        print "No poetry.lock or uv.lock found, skipping (run first 'uv sync' or 'poetry lock') ..."
      end
    else
      vim.cmd("!python " .. filepath)
    end
  elseif extension == "lua" then
    vim.cmd("!lua " .. filepath)
  elseif extension == "rs" then
    -- Asume that the project is a cargo project
    vim.cmd "!cargo run"
  elseif extension == "go" then
    vim.cmd("!go run " .. filepath)
  elseif extension == "sh" then
    vim.cmd("!source " .. filepath)
  else
    print("Unsupported file type: " .. extension .. ", skipping ...")
  end
end

function M.reload_env()
  local env_file = vim.fn.getcwd() .. "/.env"
  if vim.fn.filereadable(env_file) == 1 then
    local file = io.open(env_file, "r")
    if file then
      for line in file:lines() do
        -- Skip comments and empty lines
        if not line:match "^%s*$" and not line:match "^#" then
          local key, value = line:match "([^=]+)=(.+)"
          if key and value then
            -- Set the environment variable in Neovim
            vim.fn.setenv(key, value)
          end
        end
      end
      file:close()
    else
      print "No .env file found"
    end
    print "Reloaded .env file"
  else
    print "No .env file found"
  end
end

function M.cwd()
  -- Function to copy the absolute path to the clipboard
  local cwd = vim.fn.getcwd()
  -- local file_path = vim.fn.expand "%:p" -- Get absolute file path
  vim.fn.setreg("+", cwd) -- Copy to clipboard (system register '+')
  print("Copied absolute path: " .. cwd)
end

function M.file_wd()
  -- Function to copy the relative path to the clipboard
  local file_path = vim.fn.expand "%" -- Get relative file path
  vim.fn.setreg("+", file_path) -- Copy to clipboard (system register '+')
  print("Copied relative path: " .. file_path)
end

function M.ToggleMouse()
  if vim.o.mouse == "a" then
    vim.o.mouse = ""
    print "Mouse disabled"
  else
    vim.o.mouse = "a"
    print "Mouse enabled"
  end
end

function M.open_buffers()
  -- Alternative
  -- map(
  --   "n",
  --   "<S-h>",
  --   "<cmd>Telescope buffers sort_mru=true sort_lastused=true initial_mode=normal<cr>",
  --   { desc = "[P]Open telescope buffers" }
  -- )

  require("telescope.builtin").buffers {
    sort_mru = true,
    sort_lastused = true,
    initial_mode = "normal",
    sorting_strategy = "ascending", -- makes results go top-down
    layout_config = {
      width = 0.8,
      preview_width = 0.5,
      prompt_position = "top", -- needed for horizontal layout, but fine to keep
    },
    path_display = function(opts, path)
      local filename = vim.fn.fnamemodify(path, ":t")
      local directory = vim.fn.fnamemodify(path, ":h")
      return string.format("%s (%s)", filename, directory)
    end,
  }
end

function M.switch_terminal_buffer()
  local bufname = vim.api.nvim_buf_get_name(0)
  if string.find(bufname, "term://") then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
    vim.cmd "b#"
  else
    local buffers = vim.api.nvim_list_bufs()
    for _, bufid in pairs(buffers) do
      local bufname2 = vim.api.nvim_buf_get_name(bufid)
      if string.find(bufname2, "term://") ~= nil then
        vim.cmd("buffer " .. bufid)
        return
      end
    end

    -- Create a new terminal buffer if not found
    print "No terminal buffer found, creating a new one..."
    vim.cmd "terminal"
  end
end

function M.switch_terminal_buffer_file_wd()
  local bufname = vim.api.nvim_buf_get_name(0)
  if string.find(bufname, "term://") then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
    vim.cmd "b#"
  else
    local buffers = vim.api.nvim_list_bufs()
    for _, bufid in pairs(buffers) do
      local bufname2 = vim.api.nvim_buf_get_name(bufid)
      if string.find(bufname2, "term://") ~= nil then
        vim.cmd("buffer " .. bufid)
        return
      end
    end
    -- Get the directory of the current file, fallback to working directory
    local file_dir = vim.fn.expand "%:p:h" -- Get the directory of the current file
    if file_dir == "" then
      file_dir = vim.loop.cwd() -- Fallback to current working directory
    end

    -- Create a new terminal in the file's directory
    print("No terminal buffer found, opening a new one in: " .. file_dir)
    vim.cmd("lcd " .. vim.fn.fnameescape(file_dir)) -- Change local directory for this buffer
    vim.cmd "terminal" -- Open terminal
  end
end

function M.change_wd()
  -- Get the directory of the current file, fallback to working directory
  local file_dir = vim.fn.expand "%:p:h" -- Get the directory of the current file
  if file_dir == "" then
    file_dir = vim.loop.cwd() -- Fallback to current working directory
  end

  -- Create a new terminal in the file's directory
  print("No terminal buffer found, opening a new one in: " .. file_dir)
  vim.cmd("lcd " .. vim.fn.fnameescape(file_dir)) -- Change local directory for this buffer
end

function M.close_inactive_buffers()
  local nvimTree = "NvimTree_1" -- don't want to close nvimtree
  local current = vim.fn.bufnr "%"
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if bufnr ~= current and vim.api.nvim_buf_is_loaded(bufnr) and not bufname:match(nvimTree) then
      if not vim.api.nvim_buf_get_option(bufnr, "modified") then
        vim.cmd("bdelete " .. bufnr)
      end
    end
  end
end

-- autoclose buffers unused
function M.auto_manage_buffers(max_buffers)
  max_buffers = max_buffers or 7 -- Default to 7 buffers
  local nvimTree = "NvimTree_1"
  local current = vim.fn.bufnr "%"

  -- Get all buffers and their last used time
  local buffers = {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
    -- Filter conditions
    local is_real_buffer = vim.api.nvim_buf_is_loaded(bufnr) -- Buffer is loaded
      and buftype == "" -- Normal buffer (not special)
      and not bufname:match(nvimTree) -- Not NvimTree
      and bufnr ~= current -- Not current buffer
      and bufname ~= "" -- Not empty buffer
      and vim.api.nvim_buf_is_valid(bufnr) -- Valid buffer
    if is_real_buffer then
      table.insert(buffers, {
        bufnr = bufnr,
        last_used = vim.fn.getbufinfo(bufnr)[1].lastused,
        modified = vim.api.nvim_buf_get_option(bufnr, "modified"),
      })
    end
  end

  -- Sort buffers by last used time (oldest first)
  table.sort(buffers, function(a, b)
    return a.last_used < b.last_used
  end)

  -- Close oldest buffers if we exceed max_buffers
  local loaded_buffers = #buffers + 1 -- +1 for current buffer
  if loaded_buffers > max_buffers then
    for _, buf in ipairs(buffers) do
      if loaded_buffers <= max_buffers then
        break
      end
      if not buf.modified then
        vim.cmd("silent! bdelete " .. buf.bufnr)
        loaded_buffers = loaded_buffers - 1
      end
    end
  end
end

-- copy valid .env values easily.
function M.copy_env_values_clean()
  -- verify that this is the .env file.
  if vim.fn.expand "%:t" ~= ".env" then
    print "This is not a .env file"
    return
  end
  local env_lines = {}
  -- Read current buffer lines
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Filter lines
  for _, line in ipairs(lines) do
    -- Check if line is not empty and doesn't start with #
    if line:match "^[^#].*=.*" and line:match "%S" then
      table.insert(env_lines, line)
    end
  end

  -- Join filtered lines and copy to clipboard
  local content = table.concat(env_lines, "\n")
  vim.fn.setreg("+", content)
  print("Copied " .. #env_lines .. " environment variables to clipboard")
end

function M.add_env_values_to_buffer()
  -- in case i want to load the .env file to the current process (neotest, dap)
  local function load_env(file_name)
    local env_vars = {}
    local file = io.open(file_name, "r")

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
end

local function _parse_time_input(input)
  local hour, min = input:match "^(%d+):(%d+)$"
  if hour and min then
    return tonumber(hour), tonumber(min)
  elseif tonumber(input) then
    local now = os.date "*t"
    local future_time = os.time {
      year = now.year,
      month = now.month,
      day = now.day,
      hour = now.hour,
      min = now.min + tonumber(input),
      sec = 0,
    }
    local future_hour = os.date("%H", future_time)
    local future_min = os.date("%M", future_time)
    return tonumber(future_hour), tonumber(future_min)
  else
    print "Invalid input. Use HH:MM or a number of minutes."
    return nil, nil
  end
end

local function _schedule_notification(time_str, message)
  local hour, min = _parse_time_input(time_str)
  if not hour or not min then
    print "Can not parse time format. Use HH:MM or minutes from now."
    return
  end

  local tag = "NEOVIM_REMINDER"

  local uid = tonumber(os.getenv "UID") or tonumber(vim.fn.system "id -u")
  local cron_job = string.format(
    '%d %d * * * sh -c \'export DISPLAY=:0; export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/%d/bus; notify-send "Reminder" "%s"; crontab -l | grep -v "%s" | crontab -\' # %s',
    min,
    hour,
    uid,
    message,
    tag,
    tag
  )
  local add_cron_cmd = string.format('(crontab -l 2>/dev/null; echo "%s") | crontab -', cron_job)
  vim.fn.jobstart({ "sh", "-c", add_cron_cmd }, { detach = true })

  print("Reminder set for " .. string.format("%02d:%02d", hour, min) .. " -> " .. message)
end

function M.send_reminder_notification()
  -- Prompt for time and message to send a reminder with notify-send and crontab
  vim.ui.input({ prompt = "Enter time (HH:MM or minutes from now): " }, function(time_input)
    if not time_input or time_input == "" then
      return
    end
    vim.ui.input({ prompt = "Enter reminder message: " }, function(message)
      if not message or message == "" then
        return
      end
      _schedule_notification(time_input, message)
    end)
  end)
end

function M.messages_on_buffer()
  local messages = vim.api.nvim_exec("messages", true)

  -- Create a new scratch buffer
  vim.cmd "new"
  local buf = vim.api.nvim_get_current_buf()

  -- Set buffer options (scratch buffer)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = true

  -- Set the buffer content to the messages
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(messages, "\n"))

  -- Optional: make it readonly
  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true
  vim.bo[buf].filetype = "messages"
end

-- Done
return M
