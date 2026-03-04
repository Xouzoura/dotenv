---@diagnostic disable: undefined-global
local opt = vim.opt
local o = vim.o
local g = vim.g

-------------------------------------- options ------------------------------------------
o.laststatus = 3
o.showmode = false
o.splitkeep = "screen"

o.clipboard = "unnamedplus"
o.cursorline = true
o.cursorlineopt = "number"

-- Indenting
o.expandtab = true
o.shiftwidth = 4
o.smartindent = true
o.tabstop = 4
o.softtabstop = 4

-- Numbers
o.number = true
o.numberwidth = 4
o.relativenumber = true
o.ruler = false

o.breakindent = true
o.foldcolumn = "1" -- '0' is not bad
o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
o.foldlevelstart = 10
o.foldenable = true
-- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
o.fillchars = [[eob: ,fold: ,foldopen: ,foldsep: ,foldclose: ]]
o.inccommand = "split"
o.updatetime = 250
-- disable nvim intro
-- opt.shortmess:append "sI" -- dashboard show or not

o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400
o.undofile = true

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"
opt.showbreak = [[↪ ]]
opt.wrap = true
opt.ignorecase = true -- search case insensitive
opt.smartcase = true -- search matters if capital letter
opt.autoread = true
opt.swapfile = false

-- disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH

-- colorscheme
local cs = vim.env.NVIM_COLORSCHEME or "nightfox"
if cs and cs ~= "" then
  vim.cmd("colorscheme " .. cs)
end

-- IF I DECIDE TO USE THIS
-- if vim.fn.has("wsl") == 1 then
--   -- WSL → Windows clipboard
--   vim.g.clipboard = {
--     name = "WslClipboard",
--     copy = {
--       ["+"] = "clip.exe",
--       ["*"] = "clip.exe",
--     },
--     paste = {
--       ["+"] = "powershell.exe -NoProfile -Command Get-Clipboard",
--       ["*"] = "powershell.exe -NoProfile -Command Get-Clipboard",
--     },
--     cache_enabled = 0,
--   }
--
-- elseif vim.env.WAYLAND_DISPLAY then
--   -- Wayland Linux
--   vim.g.clipboard = {
--     name = "wl-clipboard",
--     copy = {
--       ["+"] = "wl-copy",
--       ["*"] = "wl-copy",
--     },
--     paste = {
--       ["+"] = "wl-paste --no-newline",
--       ["*"] = "wl-paste --no-newline",
--     },
--     cache_enabled = 0,
--   }
--
-- elseif vim.env.DISPLAY then
--   -- X11 Linux
--   vim.g.clipboard = {
--     name = "xclip",
--     copy = {
--       ["+"] = "xclip -selection clipboard -in",
--       ["*"] = "xclip -selection primary -in",
--     },
--     paste = {
--       ["+"] = "xclip -selection clipboard -out",
--       ["*"] = "xclip -selection primary -out",
--     },
--     cache_enabled = 0,
--   }
-- end
