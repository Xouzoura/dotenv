---@diagnostic disable: undefined-global

local autocmd = vim.api.nvim_create_autocmd

-- user event that loads after UIEnter + only if file buf is there
autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("NvFilePost", { clear = true }),
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })

    if not vim.g.ui_entered and args.event == "UIEnter" then
      vim.g.ui_entered = true
    end

    if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
      vim.api.nvim_exec_autocmds("User", { pattern = "FilePost", modeline = false })
      vim.api.nvim_del_augroup_by_name "NvFilePost"

      vim.schedule(function()
        vim.api.nvim_exec_autocmds("FileType", {})

        if vim.g.editorconfig then
          require("editorconfig").config(args.buf)
        end
      end)
    end
  end,
})

-- Start of others.
local id = vim.api.nvim_create_augroup("startup", {
  clear = false,
})
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
-- Define the highlight groups for active window/inactive window
vim.api.nvim_exec(
  [[
  autocmd WinEnter,CursorMoved * setlocal winhighlight=Normal:ActiveWindow
  autocmd WinLeave * setlocal winhighlight=Normal:InactiveWindow
]],
  false
)

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

-----------------------------------------------------------------
-- BIGFILES (disable large files from opening with lsp)
-----------------------------------------------------------------

local autogroup = vim.api.nvim_create_augroup
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

-----------------------------------------------------------------
-- DEFINE DIFFERENT COLOR FOR HIGHLIGHTING OF CURRENT WORD AND OTHERS
-----------------------------------------------------------------
function _G.set_highlights()
  vim.api.nvim_set_hl(0, "Search", { bg = "#8B8000", fg = "#000000" })
end

-- Create an augroup for highlights
vim.cmd [[
  augroup SetSearchHighlights
    autocmd!
    autocmd VimEnter,BufWinEnter,BufRead,BufNewFile * lua _G.set_highlights()
  augroup END
]]
_G.set_highlights()
