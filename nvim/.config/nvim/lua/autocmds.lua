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

-----------------------------------------------------------
------ OPEN TASKS FOR THE WEEK ----------------------------
-----------------------------------------------------------
local agenda_script =
  vim.fn.fnamemodify(vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h") .. "/../python/agenda.py", ":p")
local vault_root = vim.fn.expand "~/vaults/notes"

local function open_task_under_cursor()
  local line = vim.api.nvim_get_current_line()
  local file, lnum = line:match "%(([%w_%-%.]+%.md):(%d+)%)%s*$"
  if not file then
    vim.notify("No file:line reference on this line", vim.log.levels.WARN)
    return
  end

  local matches = vim.fn.globpath(vault_root, "**/" .. file, false, true)
  if #matches == 0 then
    vim.notify("Could not find " .. file .. " under " .. vault_root, vim.log.levels.ERROR)
    return
  end

  vim.cmd "wincmd p"
  vim.cmd("edit " .. vim.fn.fnameescape(matches[1]))
  vim.api.nvim_win_set_cursor(0, { tonumber(lnum), 0 })
end

vim.api.nvim_create_user_command("Agenda", function(opts)
  local files = opts.fargs
  if #files == 0 then
    files = { vim.fn.expand "%:p" }
  else
    files = vim.tbl_map(function(f)
      return vim.fn.expand(f)
    end, files)
  end
  local cmd = { "python3", agenda_script }
  vim.list_extend(cmd, files)
  local output = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("Agenda script failed:\n" .. output, vim.log.levels.ERROR)
    return
  end

  local prev_buf = vim.api.nvim_get_current_buf()

  vim.cmd "enew"
  local agenda_buf = vim.api.nvim_get_current_buf()
  vim.bo.buftype = "nofile"
  vim.bo.filetype = "markdown"
  vim.bo.bufhidden = "wipe"
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(output, "\n"))

  vim.keymap.set("n", "q", function()
    if vim.api.nvim_buf_is_valid(prev_buf) then
      vim.cmd("buffer " .. prev_buf)
    else
      vim.cmd "bdelete"
    end
  end, { buffer = agenda_buf })

  vim.keymap.set("n", "<CR>", open_task_under_cursor, { buffer = agenda_buf })
end, { nargs = "*", complete = "file" })

-----------------------------------------------------------
------ HIGHLIGHT DUE DATE ON MARKDOWN ---------------------
-----------------------------------------------------------
local due_ns = vim.api.nvim_create_namespace "todo_due"

local function highlight_due(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(bufnr, due_ns, 0, -1)

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for lnum, line in ipairs(lines) do
    local start_idx = 1
    while true do
      local s, e = line:find("due:%d%d%d%d%-%d%d%-%d%d", start_idx)
      if not s then
        break
      end
      vim.api.nvim_buf_set_extmark(bufnr, due_ns, lnum - 1, s - 1, {
        end_col = e,
        hl_group = "TodoDue",
      })
      start_idx = e + 1
    end
  end
end

vim.api.nvim_set_hl(0, "TodoDue", { fg = "#e06c75", bold = true })

vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
  pattern = "markdown",
  callback = function(args)
    highlight_due(args.buf)
  end,
})

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufWritePost" }, {
  pattern = "*.md",
  callback = function(args)
    highlight_due(args.buf)
  end,
})
