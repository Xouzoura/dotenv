return {
  -- db-ui within neovim with the usage of <leader>d;
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
    -- BEST WAY TO ADD NEW DB. add this to the .env file
    -- DB_UI_PRODUCTION=postgres://postgres:password@localhost:5432/db
    -- crazy easy then to add new connections

    vim.g.db_ui_use_nerd_fonts = 1
    vim.api.nvim_set_keymap(
      "n",
      "<leader>d:",
      ":DBUIToggle<CR>",
      { noremap = true, silent = true, desc = "Toggle DBUI" }
    )
    vim.api.nvim_set_keymap("n", "<leader>d>", "/|<CR>l", { desc = "Move to next column separator" })
    vim.api.nvim_set_keymap("n", "<leader>d<", "?|<CR>h", { desc = "Move to previous column separator" })
  end,
}
