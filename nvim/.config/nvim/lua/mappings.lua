---@diagnostic disable: undefined-global
---
local extras = require "extras"

-- unmaps
vim.api.nvim_del_keymap("i", "<C-u>") -- don't want whatever it did
-- base
local map = vim.keymap.set
vim.keymap.set("n", "<C-c>", "<Nop>", { noremap = true, silent = true })
vim.keymap.set("t", "<C-i>", [[<C-\><C-n>]], { noremap = true }) -- swap modes with c-i and i
vim.keymap.set("n", "<leader>W", ":noautocmd w<CR>", { desc = "Save file without formatting" })
vim.keymap.set("n", "<C-o>", "<Nop>") -- using this in tmux to switch panes.

--------------------------
--- Start the mappings ---
--------------------------

-- Disable arrow keys
map("", "<up>", "<nop>")
map("", "<right>", "<nop>")
map("", "<down>", "<nop>")
map("", "<left>", "<nop>")
--
-- movement
--
map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })
-- Save
map("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })

-- Terminal exits
map("i", "jj", "<ESC>", { silent = true })
map("i", "kj", "<ESC>", { silent = true })
-- <--- ## INSERT mode stuff ###--->
map("i", "<C-u>", "<C-BS>", { desc = "Control-u operates as backspace" })
-- map("i", "<C-d>", "<C-o>dw", { silent = true })

-- <--- ## VISUAL mode stuff ###--->
-- Moving lines up and down in visual mode
map("v", "J", [[:m '>+1<CR>gv=gv]])
map("v", "K", [[:m '<-2<CR>gv=gv]])
-- Better block tabbing
map("v", "<", "<gv", { silent = true })
map("v", ">", ">gv", { silent = true })
-- I just hate the % symbol and M is useless atm
map("n", "M", "%", { silent = true })
-- map("v", "M", "%", { silent = true })

-- <--- ## NORMAL mode stuff ###--->
-- help is <F3>
-- map("n", "<F3>", "K", { noremap = true, silent = true })
-- Center C-u and C-d, and when searching with n/N
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")
map("n", "J", "5j")
map("n", "K", "5k")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
-- close buffer, nvim, and save
map("n", "Q", ":q!<enter>", { noremap = false })
map("n", "QQ", ":qall<enter>", { noremap = false })
map("n", "E", "$", { noremap = false })
map("n", "B", "^", { noremap = false })
-- yank-delete-paste
map({ "n", "v" }, "<leader>0d", [["_d]])
map({ "n", "v" }, "<leader>0D", [["_D]])
map("n", "<leader>P", 'h"0p', { noremap = true, silent = true })
map("n", "gV", "`[v`]", { noremap = true, silent = true })
-- RUN files
map("n", "<leader>F", extras.run_file, { desc = "Exexute <F>ile" })
map("n", "g*", "*gg0nzzzv")
map("n", "g0", "*G0Nzzzv")
-- close terminal
map("t", "<Esc>", [[<c-\><c-n>]])
-- Add a newline and return to normal mode
map("n", "<leader>o", "printf('m`%so<ESC>``', v:count1)", {
  expr = true,
  desc = "insert line below",
})
map("n", "<leader>O", "printf('m`%sO<ESC>``', v:count1)", {
  expr = true,
  desc = "insert line above",
})
-- show messages
map("n", "<leader>cl", "<cmd>@:<cr>", { desc = "Repeat Last Command" })
map("n", "<leader>cm", "<cmd>messages<cr>", { desc = "View all printed messages" })
-- Resizing of windows
-- Full focus on the current window
map("n", "-", "<C-w>_<C-w>|")
-- Equalize all windows
map("n", "=", "<C-w>=")
-- Create a new window horizontally and focus on it
map("n", "g-", "<C-w>s", { noremap = false })
-- Create a new window horizontally and return to original
map("n", "g_", "<C-w>s<C-w>k", { noremap = false })
-- Create a new window vertically and focus on it
map("n", "g\\", "<C-w>v", { noremap = false })
-- Create a new window vertically and return to original
map("n", "g|", "<C-w>v<C-w>h", { noremap = false })
-- Select the whole buffer
-- map("n", "<leader>A", "ggVG", { desc = "Select all buffer", noremap = true, silent = true })
-- Resize windows vertically
map("n", "<C-W><", ":vertical resize -10<CR>", { noremap = true })
map("n", "<C-W>>", ":vertical resize +10<CR>", { noremap = true })
-- Undo with U instead of only C-r
map("n", "U", "<C-r>", { silent = true })
-- vim.api.nvim_del_keymap("n", "<C-r>")
map("n", "<C-e>", vim.lsp.buf.hover, { noremap = true, silent = true, desc = "Hover Documentation" })
-- close item from buffer
map("n", "<leader>q", "<cmd>bp<bar>sp<bar>bn<bar>bd<CR>", { desc = "Close current buffer", silent = true })
map(
  "n",
  "<leader>cb",
  extras.close_inactive_buffers,
  { silent = true, desc = "Close all buffers except the current and unsaved ones" }
)

-- Diagnostics
map("n", "<leader>df", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Diagnostic error float open" })
map("n", "<leader>dy", extras.diagnostic_copy_first_msg, { desc = "[copy] first diagnostic to clipboard" })
map("n", "<leader>dY", extras.diagnostic_copy_all_msgs, { desc = "[copy] All diagnostic to clipboard" })

-- format json file
map("n", "<leader>jj", ":%!jq .<CR>", { noremap = true, silent = true, desc = "Format file json" })
map("v", "<leader>jj", ":!jq .<CR>", { noremap = true, silent = true, desc = "Format json of area" })

map("n", "<leader>mm", extras.ToggleMouse, { desc = "disable/enable mouse", noremap = true, silent = true })
map("n", "<leader>tn", "/@pytest\\.mark\\.new<CR>", { desc = "remove 'new' marks", noremap = true, silent = true })
map("n", "gl", "<C-^>", { noremap = true, silent = true, desc = "Last buffer" })
map("n", "z;", "za<CR>", { noremap = true, silent = true, desc = "Toggle fold" })

map("n", "<leader>rq", extras.reload_env, { noremap = true, silent = true, desc = "Reload env" })
map("n", "<leader>yP", extras.cwd, { desc = "[copy] Cwd as str" })
map("n", "<leader>yF", extras.file_wd, { desc = "[copy] File as str" })
map({ "n", "t" }, "<c-y>", extras.switch_terminal_buffer, { desc = "Go to terminal buffer" })
-- map({ "n", "t" }, "<c-m>", extras.switch_terminal_buffer_file_wd, { desc = "Go to terminal buffer (of file)" })
-- map("n", "<leader>wd", extras.change_wd, { desc = "Change working directory to that of open buffer" })
map("n", "<leader>yE", extras.copy_env_values_clean, { desc = "[copy] all ACTIVE env values (without #)." })
map("n", "<leader>r,", extras.send_reminder_notification, { desc = "Reminder!", noremap = true, silent = true })
map("n", "<leader>cM", extras.messages_on_buffer, { desc = "See messages (E+W) buffer", noremap = true, silent = true })

-- quickfix
-- Toggle quickfix
map("n", "<leader>eo", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].buftype == "quickfix" then
      vim.cmd.cclose()
      return
    end
  end
  vim.cmd.copen()
end, { desc = "(Quickfix) Toggle" })

-- delete entries
map(
  "n",
  "<leader>ed",
  extras.remove_quickfix_entry,
  { desc = "remove current entry from quickfix", noremap = true, silent = true }
)
map(
  "v",
  "<leader>ed",
  extras.remove_quickfix_selection,
  { desc = "remove current entries from quickfix", noremap = true, silent = true }
)

-- Clear all quickfix entries
map("n", "<leader>e0", function()
  vim.fn.setqflist {}
  print "Quickfix list cleared"
end, { desc = "(Quickfix) Clear list" })

-- General (or python-based)
map("n", "<leader>E", ":edit .env<CR>", { desc = "Open .env file" })
map("n", "<leader>R", ":edit pyproject.toml<CR>", { desc = "Open pyproject.toml file" })
