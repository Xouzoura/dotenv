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
-- local now_playing_cache = ""
local _cache = { ts = 0, status = "", meta = "" } -- local (RAM) cache
local cache_file = "/tmp/nowplaying.cache" -- where i have the data.
local log_file = "/tmp/nowplaying.log"
local function read_cache()
  local f = io.open(cache_file, "r")
  if not f then
    return 0, "", ""
  end
  local line = f:read "*l" or ""
  f:close()
  local ts, status, meta = line:match "^(%d+)|([^|]*)|(.*)$"
  return tonumber(ts) or 0, status or "", meta or ""
end

-- write cache
local function write_cache(ts, status, meta)
  local f = io.open(cache_file, "w")
  if f then
    f:write(string.format("%d|%s|%s", ts, status or "", meta or ""))
    f:close()
  end
end

-- update player info
local function update_now_playing()
  -- expensive, so only call when caches fail.
  local max_len = 40

  local handle = io.popen "playerctl metadata --format '{{status}}|{{artist}} - {{title}}' 2>/dev/null"
  if not handle then
    write_cache(os.time(), "", "")
    return
  end

  local result = handle:read "*a" or ""
  handle:close()

  local status, meta = result:match "^(.-)|(.+)$"
  meta = meta or ""
  if not status or not meta then
    write_cache(os.time(), "", "")
    return
  end

  meta = meta:gsub("\n", "")
  if meta == "" then
    meta = "No track"
  end
  if #meta > max_len then
    meta = meta:sub(1, max_len - 3) .. "..."
  end

  write_cache(os.time(), status, meta)
  return status, meta
end

local function _format_metadata(status, meta)
  local note_icon = "♪ <"
  if status == "Playing" then
    return note_icon .. meta .. ">"
  else
    return ""
  end
end
function _G.NowPlaying()
  local now = os.time()
  -- 1. check local cache (RAM)
  if now - _cache.ts <= 3 then
    return _format_metadata(_cache.status, _cache.meta)
  end

  -- 2. check file cache
  local ts, status, meta = read_cache()
  if now - ts <= 3 then
    _cache = { ts = ts, status = status, meta = meta }
    return _format_metadata(_cache.status, _cache.meta)
  end

  -- 3. caching fails, expensive call.
  status, meta = update_now_playing()

  _cache = { ts = ts, status = status, meta = meta }
  return _format_metadata(_cache.status, _cache.meta)
end
local timer = vim.loop.new_timer()
timer:start(0, _player_ctl_status_interval_ms, vim.schedule_wrap(_G.NowPlaying))
