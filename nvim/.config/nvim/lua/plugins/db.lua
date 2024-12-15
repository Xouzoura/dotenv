return {
  -- db-ui within neovim
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
  },
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
    vim.api.nvim_set_keymap("n", "<leader>d;", ":DBUIToggle<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>d>", "/|<CR>l", { desc = "Move to next column separator" })
    vim.api.nvim_set_keymap("n", "<leader>d<", "?|<CR>h", { desc = "Move to previous column separator" })
  end,
}
