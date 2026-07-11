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
  "%{v:lua.checkLastCommit()}", -- LSP diagnostics
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
local _cache = { ts = 0, status = "", artist = "", title = "", album = "" } -- local (RAM) cache
local cache_file = "/tmp/nowplaying.cache" -- where i have the data.

local function read_cache()
  local f = io.open(cache_file, "r")
  if not f then
    return 0, "", ""
  end
  local line = f:read "*l" or ""
  f:close()
  local ts, status, artist, title, album = line:match "^(%d+)|(.-)|([^|]*)|([^|]*)|([^|]*)$"

  return tonumber(ts) or 0, status or "", artist or "", title or "", album or ""
end

-- write cache
local function write_cache(ts, status, artist, title, album)
  local f = io.open(cache_file, "w")
  if f then
    f:write(string.format("%d|%s|%s|%s|%s", ts, status or "", artist or "", title or "", album or ""))
    f:close()
  end
end

-- update player info
local function update_now_playing()
  -- FYI, i don't use it on window, just linux to test it.

  -- playerctl -a metadata --format "{{status}}|{{artist}}|{{title}}|{{album}}"
  -- Paused|The Black Crowes - Topic - She Talks To Angels
  -- Playing|Morrissey - Everyday Is Like Sunday - 2011 Remaster
  local handle =
    -- without ncspot
    -- io.popen [[playerctl -a metadata --format "{{status}}|{{artist}}|{{title}}|{{album}}" 2>/dev/null | grep "^Playing" | head -n1]]
    -- with ncspot
    io.popen [[playerctl --player ncspot -a metadata --format "{{status}}|{{artist}}|{{title}}|{{album}}" 2>/dev/null | grep "^Playing" | head -n1]]
  if not handle then
    write_cache(os.time(), "", "", "", "")
    return "", "", "", ""
  end

  local result = handle:read "*a" or ""
  handle:close()

  local status, artist, title, album = result:match "^(.-)|([^|]*)|([^|]*)|([^|]*)$"
  if not status or not title then
    write_cache(os.time(), "", "", "", "")
    return "", "", "", ""
  end

  write_cache(os.time(), status, artist, title, album)
  return status, artist, title, album
end

local function _format_metadata(status, artist, track, album)
  local max_len = 50

  artist = artist or ""
  track = track or ""
  album = album or ""

  local meta = artist .. " - " .. track .. " - [" .. album .. "]"
  meta = meta:gsub("\n", ""):gsub("\r", "")

  if meta == "" or meta == " -  - " then
    meta = "No track"
  end

  if #meta > max_len then
    meta = meta:sub(1, max_len - 3) .. "..."
  end

  if status == "Playing" then
    meta = meta:gsub("[Rr][Ee][Mm][Aa][Ss][Tt][Ee][Rr].*$", "")
    return "♪ <" .. meta .. ">"
  else
    return ""
  end
end
function _G.NowPlaying()
  local now = os.time()
  local cache_duration = 6 -- windows i expose it every 5 secs
  -- 1. check local cache (RAM)
  if _cache.ts ~= nil and (now - _cache.ts <= cache_duration) then
    return _format_metadata(_cache.status, _cache.artist, _cache.track, _cache.album)
  end

  -- 2. check file cache
  local ts, status, artist, track, album = read_cache()
  if (now - ts) <= cache_duration then
    _cache = { ts = ts, status = status, artist = artist, track = track, album = album }
    return _format_metadata(_cache.status, _cache.artist, _cache.track, _cache.album)
  end

  -- 3. caching fails, expensive call.
  if not vim.env.WSL_DISTRO_NAME then
    -- wsl doesn't do it by default, need extra scripts
    status, artist, track, album = update_now_playing()
    _cache = { ts = ts, status = status, artist = artist, track = track, album = album }
    return _format_metadata(_cache.status, _cache.artist, _cache.track, _cache.album)
  end
  -- nothing worked no song is playing or working.
  return ""
end
local _git_root_cache = {} -- { ts, is_git, message }

function _G.checkLastCommit()
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath == "" or not filepath:match("%.md$") then
    return ""
  end

  local dir = vim.fn.fnamemodify(filepath, ":h")

  -- resolve the git root for this dir (cheap-ish, but we still cache it)
  local root = vim.fn.system(
    string.format("git -C %s rev-parse --show-toplevel 2>/dev/null", vim.fn.shellescape(dir))
  ):gsub("%s+$", "")

  if root == "" or vim.v.shell_error ~= 0 then
    return "" -- not inside a git repo
  end

  local now = os.time()
  local cache_duration = 120 -- 2 minutes

  local cached = _git_root_cache[root]
  if cached ~= nil and (now - cached.ts <= cache_duration) then
    return cached.message
  end

  local message = vim.fn.system(
    string.format("git -C %s log -1 --format='%%s'", vim.fn.shellescape(root))
  ):gsub("\n$", "")

  if vim.v.shell_error ~= 0 then
    message = ""
  end

  _git_root_cache[root] = { ts = now, message = message }
  return message
end

local timer = vim.loop.new_timer()
timer:start(0, _player_ctl_status_interval_ms, vim.schedule_wrap(_G.NowPlaying))

