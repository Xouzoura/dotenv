return {
  "LintaoAmons/scratch.nvim",
  event = "VeryLazy",
  dependencies = {
    { "ibhagwan/fzf-lua" }, --optional: if you want to use fzf-lua to pick scratch file. Recommanded, since it will order the files by modification datetime desc. (require rg)
    { "nvim-telescope/telescope.nvim" }, -- optional: if you want to pick scratch file by telescope
  },
  config = function()
    vim.keymap.set("n", "<leader>sc", "<cmd>Scratch<cr>")
    vim.keymap.set("n", "<leader>so", "<cmd>ScratchOpen<cr>")
  end,
}
