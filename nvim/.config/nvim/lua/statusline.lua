---@diagnostic disable: undefined-global
-----------------------------------------------------------------
-- STATUSLINE
-----------------------------------------------------------------

vim.o.statusline = table.concat {
  -- "%f", -- filename
  "%{v:lua.ShortPath()}", -- simplified path
  -- " %m", -- modified flag
  " %=", -- separator
  "%{v:lua.NowPlaying()}", -- song
  " %=", -- separator
  "%{v:lua.LspDiagnostics()}", -- LSP diagnostics
  " %{v:lua.LspStatus()}", -- LSP status
  " %p%%", -- % of the file length
}
-- if i want something on top
-- vim.o.winbar = table.concat {
--   "%f",
--   " %m",
--   " %=",
--   " %{v:lua.LspDiagnostics()}",
--   " %{v:lua.LspStatus()}",
--   " %p%%",
-- }
-- vim.o.laststatus = 0
function _G.ShortPath()
  local _character_size = 2
  local path = vim.fn.expand "%:~:." -- relative or ~-prefixed path
  if path == "" then
    return "[No Name]"
  end

  -- skip shortening for terminal buffers
  if path:match "^term://" then
    return path
  end

  local parts = {}
  for part in string.gmatch(path, "[^/]+") do
    table.insert(parts, part)
  end

  -- only shorten if too long
  if #path <= 40 then
    return path
  end

  -- shorten: keep first char of each directory, full filename
  for i = 1, #parts - 1 do
    local p = parts[i]
    if p == "~" or p:match "^%a:$" then
      parts[i] = p
    else
      parts[i] = p:sub(1, _character_size)
    end
  end

  return table.concat(parts, "/")
end

--
-- LSP
--
function _G.LspStatus()
  local buf_clients = vim.lsp.get_clients { bufnr = 0 }
  if next(buf_clients) == nil then
    return ""
  end
  local names = {}
  for _, client in ipairs(buf_clients) do
    table.insert(names, client.name)
  end
  return "[" .. table.concat(names, ",") .. "]"
end
function _G.LspDiagnostics()
  local bufnr = vim.api.nvim_get_current_buf()
  local diags = vim.diagnostic.count(bufnr)
  if not diags or vim.tbl_isempty(diags) then
    return ""
  end
  local err = diags[vim.diagnostic.severity.ERROR] or 0
  local warn = diags[vim.diagnostic.severity.WARN] or 0
  local hint = diags[vim.diagnostic.severity.HINT] or 0
  local info = diags[vim.diagnostic.severity.INFO] or 0
  return string.format(" E:%d W:%d", err, warn, hint, info)
end

--
-- MUSIC
-- Add what is playing (if it's playing).
-- Using cache since it can be annoying fetching every redraw the song
--
local _player_ctl_status_interval_ms = 3000
local now_playing_cache = ""
function _G._NowPlaying()
  local max_len = 40
  local note_icon = "♪ <"
  local status_handle = io.popen "playerctl status 2>/dev/null"
  if not status_handle then
    return ""
  end
  local status = status_handle:read "*a" or ""
  status_handle:close()

  if not status:match "Playing" then
    return ""
  end

  -- now we are still playing
  local handle = io.popen "playerctl metadata --format '{{ artist }} - {{ title }}' 2>/dev/null"
  if handle == nil then
    return ""
  end
  local result = handle:read "*a"
  handle:close()
  result = result:gsub("\n", "") -- remove newline
  if result == "" then
    return "No track"
  end
  if #result > max_len then
    result = result:sub(1, max_len - 3) .. "..."
  end
  return note_icon .. result .. ">"
end

function _G.NowPlaying()
  return now_playing_cache ~= "" and now_playing_cache or ""
end
local timer = vim.loop.new_timer()

timer:start(
  0,
  _player_ctl_status_interval_ms,
  vim.schedule_wrap(function()
    now_playing_cache = _G._NowPlaying()
  end)
)
