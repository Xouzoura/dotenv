---@diagnostic disable: undefined-global
---
require "nvchad.mappings"
local extras = require "extras"

-- unmaps
vim.api.nvim_del_keymap("i", "<C-u>")
vim.api.nvim_del_keymap("n", "<leader>x")
vim.keymap.set("n", "<C-o>", "<Nop>") -- using this in tmux to switch panes.
-- Start the mapping
local map = vim.keymap.set
-- Disable arrow keys
map("", "<up>", "<nop>")
map("", "<right>", "<nop>")
map("", "<down>", "<nop>")
map("", "<left>", "<nop>")

-- Terminal exits
map("t", "kj", [[<C-\><C-n>]], { noremap = true, silent = true })
map("t", "jj", [[<C-\><C-n>]], { noremap = true, silent = true })
-- <--- ## INSERT mode stuff ###--->
map("i", "<C-u>", "<C-BS>", { desc = "Control-u operates as backspace" })
map("i", "jj", "<ESC>", { silent = true })
map("i", "kj", "<ESC>", { silent = true })
map("i", "<C-d>", "<C-o>dw", { silent = true })

-- <--- ## VISUAL mode stuff ###--->
-- Moving lines up and down in visual mode
map("v", "J", [[:m '>+1<CR>gv=gv]])
map("v", "K", [[:m '<-2<CR>gv=gv]])
-- Better block tabbing
map("v", "<", "<gv", { silent = true })
map("v", ">", ">gv", { silent = true })

-- <--- ## NORMAL mode stuff ###--->
-- help is <F3>
map("n", "<F3>", "K", { noremap = true, silent = true })
-- Center C-u and C-d, and when searching with n/N
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")
map("n", "J", "5j")
map("n", "K", "5k")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map({ "n", "v" }, "<leader>kd", [["_d]])
map({ "n", "v" }, "<leader>kD", [["_D]])
-- Yank to system clipboard
map({ "n", "v" }, "<leader>sy", [["+y]])
map("n", "<leader>sY", [["+Y]])
-- Paste from system clipboard
map({ "n", "v" }, "<leader>sp", [["+p]])
map("n", "<leader>sP", [["+P]])
-- RUN files
map("n", "<leader>xf", extras.run_file, { desc = "E<x>exute <f>ile" })
map("n", "g*", "*gg0nzzzv") -- Decide which i like more
map("n", "g0", "*GNzzzv")
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
map("n", "<leader>A", "ggVG", { desc = "Select all buffer", noremap = true, silent = true })
-- Resize windows vertically
map("n", "<C-W>,", ":vertical resize -10<CR>", { noremap = true })
map("n", "<C-W>.", ":vertical resize +10<CR>", { noremap = true })
-- Undo with U instead of only C-r
map("n", "U", "<C-r>", { silent = true })
-- close item from buffer
map("n", "<leader>q", "<cmd>bp<bar>sp<bar>bn<bar>bd<CR>", { desc = "Close current buffer", silent = true })
map(
  "n",
  "<leader>cb",
  extras.close_inactive_buffers,
  { silent = true, desc = "Close all buffers except the current and unsaved ones" }
)

-- format json file
map("n", "<leader>jj", ":%!jq .<CR>", { noremap = true, silent = true })
-- close buffer, nvim, and save
map("n", "Q", ":q!<enter>", { noremap = false })
map("n", "QQ", ":qall<enter>", { noremap = false })
map("n", "E", "$", { noremap = false })
map("n", "B", "^", { noremap = false })
-- Paste from system clipboard
map("n", "<leader>P", 'h"0p', { noremap = true, silent = true })
-- Keymaps view on telescope
map("n", "<leader>kk", function()
  require("telescope.builtin").keymaps()
end, { desc = "Keymaps on telescope" })
-- git commands that are useful
map("n", "<leader>gf", "<cmd>Telescope git_bcommits<CR>", {
  desc = "Search git bcommits on current <f>ile",
})
map("n", "<leader>ga", "<cmd>Telescope git_commits<CR>", {
  desc = "Search git commits on <a>ll files",
})
map("n", "<leader>gb", '<cmd>lua require("gitsigns").toggle_current_line_blame()<CR>', {
  desc = "Git toggle <b>lame by line",
})

map("n", "<leader>mm", extras.ToggleMouse, { desc = "disable/enable mouse", noremap = true, silent = true })
map("n", "<leader>tn", "/@pytest\\.mark\\.new<CR>", { desc = "remove new tests", noremap = true, silent = true })

-------------------------
-- PLUGINS --------------
-------------------------
-- Oil
map("n", "g;", ":Oil<CR>", { noremap = true, silent = true, desc = "Open oil" })
map("n", "g:", function()
  local proj_pwd = vim.fn.getcwd()
  require("oil").open(proj_pwd)
  -- Below is if you want to open the preview window by default
  -- local oil = require "oil"
  -- require("oil.util").run_after_load(0, function()
  --   oil.open_preview()
  -- end)
end)
-- Debug prints (plugins/debug.lua)
map("n", "<leader>d[", "<CMD>ToggleCommentDebugPrints<CR>", { desc = "Toggle on/off debug statements" })
map("n", "<leader>d]", "<CMD>DeleteDebugPrints<CR>", { desc = "Toggle on/off debug statements" })
-- Copilot (enable/disable, but enabled by default) (plugins/copilot.lua)
map("n", "<leader>cpd", "<CMD>Copilot disable<CR>", { desc = "Disable copilot", noremap = true, silent = true })
map("n", "<leader>cpe", "<CMD>Copilot enable<CR>", { desc = "Enable copilot", noremap = true, silent = true })
map("i", "<C-]>", 'copilot#Accept("<CR>")', { silent = true, expr = true, replace_keycodes = false })
-- git signs (part of default config from nvchad)
map("n", "<leader>gdd", "<cmd>DiffviewOpen<CR>", {
  desc = "(gitsigns) Diff with HEAD",
})
map("n", "<leader>gdm", "<cmd>DiffviewOpen develop..HEAD <CR>", {
  desc = "(gitsigns) Diff with dev",
})
map("n", "<leader>gdf", "<cmd>DiffviewFileHistory % <CR>", {
  desc = "(gitsigns) Diff file",
})
map("n", "<leader>gdc", "<cmd>DiffviewClose<CR>", {
  desc = "(gitsigns) Close",
})
-- terminal of open buffers
map("n", "<leader><leader>", function()
  require("telescope").extensions.smart_open.smart_open { cwd_only = true }
end, { noremap = true, silent = true, desc = "Smart open of telescope files (within directory)" })
map("n", "<S-h>", extras.open_buffers, { desc = "[P]Open telescope buffers" })
-- telescope
map("n", "<leader>fe", "<cmd>Telescope grep_string<cr>", { desc = "[P]Find grep current word" })
map("n", "<leader>f.", function()
  local file_dir = vim.fn.expand "%:p:h" -- Get the current file's directory
  require("telescope.builtin").live_grep { search_dirs = { file_dir } }
end, { desc = "[P]Search grep in current file's directory" })
map("n", "<leader>rr", extras.reload_env, { noremap = true, silent = true })
map("n", "<leader>yp", extras.cwd, { desc = "Copy current working path" })
map("n", "<leader>yf", extras.file_wd, { desc = "Copy current file path" })
map({ "n", "t" }, "g.", extras.switch_terminal_buffer, { desc = "Go to terminal buffer" })
