return {
  -- haven't used it in a while
  "LintaoAmons/scratch.nvim",
  event = "VeryLazy",
  -- enabled = false,
  dependencies = {
    { "ibhagwan/fzf-lua" }, --optional: if you want to use fzf-lua to pick scratch file. Recommanded, since it will order the files by modification datetime desc. (require rg)
    { "nvim-telescope/telescope.nvim" }, -- optional: if you want to pick scratch file by telescope
  },
  config = function()
    vim.keymap.set("n", "<leader>sc", "<cmd>Scratch<cr>", { desc = "<scratch> Create" })
    vim.keymap.set("n", "<leader>so", "<cmd>ScratchOpen<cr>", { desc = "<scratch> Open" })
  end,
}
