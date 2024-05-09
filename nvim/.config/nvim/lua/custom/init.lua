-- Set laststatus to 2 to always display the statusline
vim.opt.laststatus = 2
-- Set statusline to display the filename
vim.opt.statusline = "%t"
-- Example: Set tab width to 4 spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
-- vim.opt.expandtab = true

-- Example: Enable line numbers and relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Make yank one that ignored the delete
vim.api.nvim_set_keymap('n', '<Leader>P', '"0p', { noremap = true, silent = true })

-- nvim-ufo
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 10
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
-- vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
-- vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

-- Copilot
-- vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-]>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

-- Lua
-- Trouble
vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)
-- Spectre
vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
    desc = "Toggle Spectre"
})
vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = "Search current word"
})
vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
    desc = "Search current word"
})
vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
    desc = "Search on current file"
})
-- Precognition
vim.keymap.set('n', '<leader>pr', '<cmd>lua require("precognition").toggle()<CR>', {
    desc = "Precognition toggle"
})

-- git commands that are useful
vim.keymap.set('n', '<leader>gf', '<cmd>Telescope git_bcommits<CR>', {
    desc = "Search git bcommits on current <f>ile"
})
vim.keymap.set('n', '<leader>ga', '<cmd>Telescope git_commits<CR>', {
    desc = "Search git commits on <a>ll files"
})
vim.keymap.set('n', '<leader>gb', '<cmd>lua require("gitsigns").toggle_current_line_blame()<CR>', {
    desc = "Git toggle <b>lame by line"
})
local opts = {}
-- To do 
vim.api.nvim_set_keymap("n", "<leader>TDL", "<CMD>TodoLocList<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>TDT", "<CMD>TodoTelescope<CR>", opts)
-- Replace
vim.api.nvim_set_keymap("v", "<C-r>", "<CMD>SearchReplaceSingleBufferVisualSelection<CR>", opts)
vim.api.nvim_set_keymap("v", "<C-s>", "<CMD>SearchReplaceWithinVisualSelection<CR>", opts)
vim.api.nvim_set_keymap("v", "<C-b>", "<CMD>SearchReplaceWithinVisualSelectionCWord<CR>", opts)

vim.api.nvim_set_keymap("n", "<leader>rs", "<CMD>SearchReplaceSingleBufferSelections<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>ro", "<CMD>SearchReplaceSingleBufferOpen<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rw", "<CMD>SearchReplaceSingleBufferCWord<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rW", "<CMD>SearchReplaceSingleBufferCWORD<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>re", "<CMD>SearchReplaceSingleBufferCExpr<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rf", "<CMD>SearchReplaceSingleBufferCFile<CR>", opts)

vim.api.nvim_set_keymap("n", "<leader>rbs", "<CMD>SearchReplaceMultiBufferSelections<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rbo", "<CMD>SearchReplaceMultiBufferOpen<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rbw", "<CMD>SearchReplaceMultiBufferCWord<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rbW", "<CMD>SearchReplaceMultiBufferCWORD<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rbe", "<CMD>SearchReplaceMultiBufferCExpr<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rbf", "<CMD>SearchReplaceMultiBufferCFile<CR>", opts)

vim.api.nvim_set_keymap("n", "<leader>to", "<CMD>TSJToggle<CR>", opts)
vim.o.inccommand = "split"
-- Close the inactive tabs
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

vim.keymap.set('n', '<Leader>ct',
  function()
    vim.t.bufs = vim.tbl_filter(function(bufnr)
      return vim.api.nvim_buf_get_option(bufnr, "modified")
    end, vim.t.bufs)
  end, { silent = true, desc = 'Close unused buffers' })
