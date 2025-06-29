---@diagnostic disable: undefined-global
require "nvchad.options"

local extras = require "extras"
-- Settings
-- global
vim.o.mouse = "a"
vim.o.breakindent = true
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 10
vim.o.foldenable = true
-- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.fillchars = [[eob: ,fold: ,foldopen: ,foldsep: ,foldclose: ]]
vim.o.inccommand = "split"
vim.o.updatetime = 250
vim.o.cursorline = true
-- opts
vim.opt.laststatus = 2
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.ignorecase = true -- search case insensitive
vim.opt.smartcase = true -- search matters if capital letter
vim.opt.inccommand = "split" -- "for incsearch while sub
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.wrap = true
vim.opt.showbreak = [[↪ ]]
vim.opt.breakindent = true
-- sync buffers automatically
vim.opt.autoread = true
-- disable neovim generating a swapfile and showing a warning
vim.opt.swapfile = false
vim.wo.signcolumn = "yes"
-- Already defined at diagnostics.lua
-- vim.diagnostic.config { virtual_text = true, severity_sort = true, signs = true }
local id = vim.api.nvim_create_augroup("startup", {
  clear = false,
})
-- vim.api.nvim_set_hl(0, "CursorLine", { bg = "#282C34", fg = "#F8F8F2" })
local persistbuffer = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  vim.fn.setbufvar(bufnr, "bufpersist", 1)
end

vim.api.nvim_create_autocmd({ "BufRead" }, {
  group = id,
  pattern = { "*" },
  callback = function()
    vim.api.nvim_create_autocmd({ "InsertEnter", "BufModifiedSet" }, {
      buffer = 0,
      once = true,
      callback = function()
        persistbuffer()
      end,
    })
  end,
})

-- Highlight the active window
vim.api.nvim_exec(
  [[
  autocmd WinEnter,CursorMoved * setlocal winhighlight=Normal:ActiveWindow
  autocmd WinLeave * setlocal winhighlight=Normal:InactiveWindow
]],
  false
)

-- Define the highlight groups for active window/inactive window
vim.cmd "highlight ActiveWindow guibg=None guifg=None"
vim.cmd "highlight InactiveWindow guibg=#2c2f34"

-- highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank { timeout = 300 }
  end,
  group = highlight_group,
  pattern = "*",
})

-- disable large files from opening with lsp
local autocmd = vim.api.nvim_create_autocmd
local autogroup = vim.api.nvim_create_augroup

-- Disable certain features when opening large files
local big_file = autogroup("BigFile", { clear = true })
vim.filetype.add {
  pattern = {
    [".*"] = {
      function(path, buf)
        return vim.bo[buf]
            and vim.bo[buf].filetype ~= "bigfile"
            and path
            and vim.fn.getfsize(path) > 1024 * 300
            and "bigfile"
          or nil -- bigger than 300KB
      end,
    },
  },
}

autocmd({ "FileType" }, {
  group = big_file,
  pattern = "bigfile",
  callback = function(ev)
    vim.cmd "syntax off"
    vim.opt_local.foldmethod = "manual"
    vim.opt_local.spell = false
    vim.schedule(function()
      vim.bo[ev.buf].syntax = vim.filetype.match { buf = ev.buf } or ""
    end)
  end,
})

-- Define a function to set highlights for search
function set_highlights()
  vim.api.nvim_set_hl(0, "Search", { bg = "#8B8000", fg = "#000000" })
end

-- Create an augroup for highlights
vim.cmd [[
  augroup SetSearchHighlights
    autocmd!
    autocmd VimEnter,BufWinEnter,BufRead,BufNewFile * lua set_highlights()
  augroup END
]]
set_highlights()

-- Create a command in Neovim
-- vim.api.nvim_create_user_command("Reminder", extras.prompt_notification, {})
--
-- vim.keymap.set("n", "<Leader>r,", extras.prompt_notification, { noremap = true, silent = true })
-- Decide if I want it to keep max buffers
-- local extras = require "extras"
-- vim.api.nvim_create_autocmd({ "BufAdd", "BufEnter" }, {
--   callback = function()
--     extras.auto_manage_buffers(7)
--   end,
-- })
--
-- USEFUL FOR FINDING WHICH LIBRARY IS CAUSING A PROBLEM
-- local old_notify = vim.notify
-- vim.notify = function(msg, ...)
--   if msg:match "position_encoding" then
--     print(debug.traceback())
--   end
--   old_notify(msg, ...)
-- end
