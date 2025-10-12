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

-- disable large files from opening with lsp
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
vim.o.statusline = table.concat {
  "%f",
  " %m",
  " %=",
  " %{v:lua.LspDiagnostics()}", -- LSP diagnostics
  " %{v:lua.LspStatus()}",
  " %p%%",
}
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
