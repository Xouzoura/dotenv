require "nvchad.options"

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

-- Highlight useful patterns for easy copy paste
function FindAndSelectPattern()
  -- does not work perfectly, but it's a start
  local patterns = {
    url_https = "(https?://[%w%.%-/:#%?%&_=]+)",
    url_http = "(http?://[%w%.%-/:#%?%&_=]+)",
    -- file_path = "([%w%p]+/[.%w%p]+)",
    uuid = "%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x",
    -- sha_pattern_7 = "%x%x%x%x%x%x%x%x",
    -- sha_pattern = "[0-9a-fA-F]{7,40}",
    ip = "%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?",
    address = "0x[0-9a-fA-F]+",
    token_pattern = "eyJ[%w%p]+",
  }
  local api = vim.api
  local hint_chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  local ns_id = api.nvim_create_namespace "uuid_highlight"

  local bufnr = api.nvim_get_current_buf()
  local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local hints = {}
  local hint_idx = 1

  api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
  for i, line in ipairs(lines) do
    for pattern_name, pattern in pairs(patterns) do
      for start_pos, match in line:gmatch("()(" .. pattern .. ")") do
        if hint_idx <= #hint_chars then
          local hint_char = hint_chars:sub(hint_idx, hint_idx)
          table.insert(hints, { char = hint_char, match = match, line = i, start_pos = start_pos })
          api.nvim_buf_add_highlight(bufnr, ns_id, "IncSearch", i - 1, start_pos - 1, start_pos + #match - 1)
          api.nvim_buf_set_extmark(bufnr, ns_id, i - 1, start_pos - 1, {
            virt_text = { { hint_char, "Error" } },
            virt_text_pos = "overlay",
          })

          hint_idx = hint_idx + 1
        end
      end
    end
  end
  local function select_hint()
    local char = vim.fn.getcharstr()

    if char == "\27" then -- Escape key
      api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
      return
    end

    for _, hint in ipairs(hints) do
      if hint.char == char then
        vim.fn.setreg("+", hint.match)

        api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
        print("Copied ", hint.match)
        return
      end
    end
  end

  -- Force a screen redraw
  vim.cmd "redraw"

  if #hints > 0 then
    select_hint()
  end
end

-- Map the function to a keybinding, e.g., <leader>cu
vim.api.nvim_set_keymap("n", "<leader>cu", ":lua FindAndSelectPattern()<CR>", { noremap = true, silent = true })
