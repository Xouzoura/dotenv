require "nvchad.options"

-- Settings 
-- global
vim.o.mouse = "a"
vim.o.breakindent = true
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 10
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.inccommand = "split"
vim.o.updatetime = 250
--
-- opts
vim.opt.laststatus = 2
vim.opt.statusline = "%t"
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
vim.wo.signcolumn = 'yes'

local id = vim.api.nvim_create_augroup("startup", {
  clear = false
})

local persistbuffer = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  vim.fn.setbufvar(bufnr, 'bufpersist', 1)
end

vim.api.nvim_create_autocmd({"BufRead"}, {
  group = id,
  pattern = {"*"},
  callback = function()
    vim.api.nvim_create_autocmd({"InsertEnter","BufModifiedSet"}, {
      buffer = 0,
      once = true,
      callback = function()
        persistbuffer()
      end
    })
  end
})

-- Highlight the active window
vim.api.nvim_exec([[
  autocmd WinEnter,CursorMoved * setlocal winhighlight=Normal:ActiveWindow
  autocmd WinLeave * setlocal winhighlight=Normal:InactiveWindow
]], false)

-- Define the highlight groups for active window/inactive window
vim.cmd('highlight ActiveWindow guibg=None guifg=None')
vim.cmd('highlight InactiveWindow guibg=#2c2f34')

-- highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout=300 })
    end,
    group = highlight_group,
    pattern = "*",
})
