---@diagnostic disable: undefined-global
local M = {}
--
function M.run_file()
  local filepath = vim.fn.expand "%:p"
  local extension = vim.fn.fnamemodify(filepath, ":e")

  if extension == "py" then
    -- Check for pyproject.toml to use poetry
    if vim.fn.filereadable(vim.fn.expand "pyproject.toml") == 1 then
      vim.cmd("!poetry run python " .. filepath)
    else
      vim.cmd("!python " .. filepath)
    end
  elseif extension == "go" then
    vim.cmd("!go run " .. filepath)
  elseif extension == "sh" then
    vim.cmd("!source " .. filepath)
  else
    print("Unsupported file type: " .. extension)
  end
end
--
function M.reload_env()
  local env_file = vim.fn.getcwd() .. "/.env"
  if vim.fn.filereadable(env_file) == 1 then
    local file = io.open(env_file, "r")
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
    print "Reloaded .env file"
  else
    print "No .env file found"
  end
end
--
function M.cwd()
  -- Function to copy the absolute path to the clipboard
  local cwd = vim.fn.getcwd()
  -- local file_path = vim.fn.expand "%:p" -- Get absolute file path
  vim.fn.setreg("+", cwd) -- Copy to clipboard (system register '+')
  print("Copied absolute path: " .. cwd)
end
--
function M.file_wd()
  -- Function to copy the relative path to the clipboard
  local file_path = vim.fn.expand "%" -- Get relative file path
  vim.fn.setreg("+", file_path) -- Copy to clipboard (system register '+')
  print("Copied relative path: " .. file_path)
end
--
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
  require("telescope.builtin").buffers {
    sort_mru = true,
    sort_lastused = true,
    initial_mode = "normal",
    path_display = function(opts, path)
      local filename = vim.fn.fnamemodify(path, ":t")
      local directory = vim.fn.fnamemodify(path, ":h")
      return string.format("%s (%s)", filename, directory)
    end,
  }
end
-- Done
return M
