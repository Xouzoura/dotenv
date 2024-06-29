require "nvchad.mappings"
-- Start the mapping
local map = vim.keymap.set

-- unmaps
vim.api.nvim_del_keymap('i', '<C-u>')  
vim.api.nvim_del_keymap('n', '<leader>x')  
-- Disable arrow keys
map("", "<up>", "<nop>")
map("", "<right>", "<nop>")
map("", "<down>", "<nop>")
map("", "<left>", "<nop>")

-- <--- ## INSERT mode stuff ###--->
map("i", "<C-u>", "<C-BS>", {desc = "Control-u operates as backspace"})
map("i", "jj", "<ESC>", { silent = true })
map("i", "kj", "<ESC>", { silent = true })
map("i", "<C-d>", "<C-o>dw", { silent = true })
-- accept copilot with c] and cy
map("i", "<C-]>", 'copilot#Accept("<CR>")', { silent = true, expr = true, replace_keycodes = false }) -- Copilot
map("i", "<C-f>", 'copilot#Accept("<CR>")', { silent = true, expr = true, replace_keycodes = false }) -- Copilot

-- <--- ## VISUAL mode stuff ###--->
-- Moving lines up and down in visual mode
map("v", "J", [[:m '>+1<CR>gv=gv]])
map("v", "K", [[:m '<-2<CR>gv=gv]])
-- Better block tabbing
map("v", "<", "<gv", { silent = true })
map("v", ">", ">gv", { silent = true })

-- <--- ## NORMAL mode stuff ###--->
-- Center C-u and C-d
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")
map("t", "<Esc>", [[<c-\><c-n>]])
map("n", "<leader>o", "printf('m`%so<ESC>``', v:count1)", {
  expr = true,
  desc = "insert line below",
})
map("n", "<leader>O", "printf('m`%sO<ESC>``', v:count1)", {
  expr = true,
  desc = "insert line above",
})
-- Resizing of windows
-- Full focus on the current window
map("n", "-", "<C-w>_<C-w>|")
-- Equalize all windows
map("n", "=", "<C-w>=")
-- Create a new window horizontally and focus on it
map("n", "g-", "<C-w>s", {noremap=false})
-- Create a new window horizontally and return to original
map("n", "g_", "<C-w>s<C-w>k", {noremap=false})
-- Create a new window vertically and focus on it
map("n", "g\\", "<C-w>v", {noremap=false})
-- Create a new window vertically and return to original
map("n", "g|", "<C-w>v<C-w>h", {noremap=false})
-- Select the whole buffer
map("n", "<leader>A", "ggVG")
-- Resize windows vertically
map("n", "<C-W>,", ":vertical resize -10<CR>", {noremap=true})
map("n", "<C-W>.", ":vertical resize +10<CR>", {noremap=true})
-- Undo with U instead of only C-r
map("n", "U", "<C-r>", { silent = true })
-- close item from buffer
map("n", "<leader>q", "<cmd>bp<bar>sp<bar>bn<bar>bd<CR>", {desc="Close current buffer", silent = true })
-- close all buffers
map("n", "<leader>cb", function()
    require("nvchad.tabufline").closeAllBufs()
    vim.cmd("wincmd h")
end, { silent = true, desc = "Close all buffers" })
-- close inactive buffers
map('n', '<leader>ct',
  function()
    vim.t.bufs = vim.tbl_filter(function(bufnr)
      return vim.api.nvim_buf_get_option(bufnr, "modified")
    end, vim.t.bufs)
  end, { silent = true, desc = 'Close unused buffers' })

-- close buffer, nvim, and save
map("n", "QQ", ":q!<enter>", {noremap=false})
map("n", "QA", ":qall<enter>", {noremap=false})
map("n", "QW", ":w!<enter>", {noremap=false})
map("n", "E", "$", {noremap=false})
map("n", "B", "^", {noremap=false})
map("n", "<leader>nn", ":Noice dismiss<CR>", {noremap=true})
-- Paste from system clipboard 
map('n', '<leader>P', 'h"0p', { noremap = true, silent = true })
-- Keymaps view on telescope
map("n", "<leader>tk", function() require("telescope.builtin").keymaps() end, { desc = "Keymaps on telescope" })
-- Spectre
map('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
    desc = "Toggle Spectre"
})
map('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = "Search current word"
})
map('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
    desc = "Search current word"
})
map('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
    desc = "Search on current file"
})
-- Telescope the most important files on the project as determined by telescope
map("n", "<leader>fc", function ()
  require("telescope").extensions.smart_open.smart_open()
end, { noremap = true, silent = true, desc = "Smart open of telescope files" })
map("n", "<leader><leader>", function ()
  require("telescope").extensions.smart_open.smart_open({cwd_only = true})
end, { noremap = true, silent = true, desc = "Smart open of telescope files (within directory)" })
-- map("n", "<leader>to", "<CMD>Hardtime toggle<CR>", opts)
-- git commands that are useful
map('n', '<leader>gf', '<cmd>Telescope git_bcommits<CR>', {
    desc = "Search git bcommits on current <f>ile"
})
map('n', '<leader>ga', '<cmd>Telescope git_commits<CR>', {
    desc = "Search git commits on <a>ll files"
})
map('n', '<leader>gb', '<cmd>lua require("gitsigns").toggle_current_line_blame()<CR>', {
    desc = "Git toggle <b>lame by line"
})
local opts = {}
-- To do 
map("n", "<leader>TDL", "<CMD>TodoLocList<CR>", opts)
map("n", "<leader>TDT", "<CMD>TodoTelescope<CR>", opts)
-- Replace
map("v", "<C-r>", "<CMD>SearchReplaceSingleBufferVisualSelection<CR>", opts)
map("v", "<C-s>", "<CMD>SearchReplaceWithinVisualSelection<CR>", opts)
map("v", "<C-b>", "<CMD>SearchReplaceWithinVisualSelectionCWord<CR>", opts)

map("n", "<leader>rs", "<CMD>SearchReplaceSingleBufferSelections<CR>", opts)
map("n", "<leader>ro", "<CMD>SearchReplaceSingleBufferOpen<CR>", opts)
map("n", "<leader>rw", "<CMD>SearchReplaceSingleBufferCWord<CR>", opts)
map("n", "<leader>rW", "<CMD>SearchReplaceSingleBufferCWORD<CR>", opts)
map("n", "<leader>re", "<CMD>SearchReplaceSingleBufferCExpr<CR>", opts)
map("n", "<leader>rf", "<CMD>SearchReplaceSingleBufferCFile<CR>", opts)

map("n", "<leader>rbs", "<CMD>SearchReplaceMultiBufferSelections<CR>", opts)
map("n", "<leader>rbo", "<CMD>SearchReplaceMultiBufferOpen<CR>", opts)
map("n", "<leader>rbw", "<CMD>SearchReplaceMultiBufferCWord<CR>", opts)
map("n", "<leader>rbW", "<CMD>SearchReplaceMultiBufferCWORD<CR>", opts)
map("n", "<leader>rbe", "<CMD>SearchReplaceMultiBufferCExpr<CR>", opts)
map("n", "<leader>rbf", "<CMD>SearchReplaceMultiBufferCFile<CR>", opts)

-- ChatGPT
local function keymapOptions(desc)
    return {
        noremap = true,
        silent = true,
        nowait = true,
        desc = "GPT prompt " .. desc,
    }
end

-- Chat ai commands  
map({"n", "i"}, "<C-g>c", "<cmd>GpChatNew<cr>", keymapOptions("New Chat"))
map({"n", "i"}, "<C-g>t", "<cmd>GpChatToggle<cr>", keymapOptions("Toggle Chat"))
map({"n", "i"}, "<C-g>f", "<cmd>GpChatFinder<cr>", keymapOptions("Chat Finder"))

map("v", "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>", keymapOptions("Visual Chat New"))
map("v", "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", keymapOptions("Visual Chat Paste"))
map("v", "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", keymapOptions("Visual Toggle Chat"))
map({"n", "i"}, "<C-g>gp", "<cmd>GpPopup<cr>", keymapOptions("Popup"))
map({"n", "i", "v", "x"}, "<C-g>s", "<cmd>GpStop<cr>", keymapOptions("Stop"))
map({"n", "i", "v", "x"}, "<C-g>n", "<cmd>GpNextAgent<cr>", keymapOptions("Next Agent"))

-- Mouse enable/disable
-- Function to toggle mouse support
function ToggleMouse()
    if vim.o.mouse == 'a' then
        vim.o.mouse = ''
        print("Mouse disabled")
    else
        vim.o.mouse = 'a'
        print("Mouse enabled")
    end
end
map('n', '<leader>mm', ':lua ToggleMouse()<CR>', {desc="disable/enable mouse", noremap = true, silent = true })
-- Function to enter the black hole register
local function black_hole_register()
    -- vim.api.nvim_feedkeys('"_', 'n', true)
    vim.fn.feedkeys('"_', 'n')
end

-- Map Ctrl+` to enter the black hole register
vim.api.nvim_set_keymap('n', '<C-`>', ':lua black_hole_register()<CR>', { noremap = true, silent = true })
