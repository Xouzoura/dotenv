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
-- vim.opt.hidden = true
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
-- new
-- Function to find UUIDs and temporarily highlight them with unique letter hints
function FindAndSelectUUID()
  local api = vim.api
  local hint_chars = "abcdefghijklmnopqrstuvwxyz"
  local ns_id = api.nvim_create_namespace "uuid_highlight"

  local bufnr = api.nvim_get_current_buf()
  local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local uuid_pattern = "%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x"
  local hints = {}
  local hint_idx = 1

  -- Clear previous highlights and temp hints
  api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)

  -- Search for UUIDs and highlight them without modifying buffer content
  for i, line in ipairs(lines) do
    for start_pos, uuid in line:gmatch("()(" .. uuid_pattern .. ")") do
      if hint_idx <= #hint_chars then
        local hint_char = hint_chars:sub(hint_idx, hint_idx)
        table.insert(hints, { char = hint_char, uuid = uuid, line = i, start_pos = start_pos })

        -- Highlight the entire UUID
        api.nvim_buf_add_highlight(bufnr, ns_id, "IncSearch", i - 1, start_pos - 1, start_pos + #uuid - 1)

        -- Show the hint character (virtual text) next to the UUID without modifying buffer text
        api.nvim_buf_set_extmark(bufnr, ns_id, i - 1, start_pos - 1, {
          virt_text = { { hint_char, "Error" } }, -- Use virtual text to show hint character
          virt_text_pos = "overlay", -- Position it over the UUID
        })

        hint_idx = hint_idx + 1
      end
    end
  end
  -- Force a screen redraw
  vim.cmd "redraw"
  -- Function to listen for user input and copy selected UUID
  local function select_hint()
    local char = vim.fn.getcharstr()

    -- Clear the highlights and virtual text if the user presses Escape
    if char == "\27" then -- Escape key
      api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
      return
    end

    for _, hint in ipairs(hints) do
      if hint.char == char then
        -- Copy the selected UUID to the clipboard
        vim.fn.setreg("+", hint.uuid)

        -- Clear the highlights and virtual text after selection
        api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
        return
      end
    end
  end

  if #hints > 0 then
    select_hint()
  end
end

-- Map the function to a keybinding, e.g., <leader>cu
vim.api.nvim_set_keymap("n", "<leader>cu", ":lua FindAndSelectUUID()<CR>", { noremap = true, silent = true })
