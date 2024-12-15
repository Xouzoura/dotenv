return {
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  -- enabled = false,
  lazy = false,

  config = function()
    require("treesitter-context").setup {
      max_lines = 10,
      enable = false,
    }
    vim.api.nvim_set_keymap(
      "n",
      "<leader>t,",
      "<cmd>TSContextToggle<CR>",
      { desc = "Move to previous column separator" }
    )
  end,
}
