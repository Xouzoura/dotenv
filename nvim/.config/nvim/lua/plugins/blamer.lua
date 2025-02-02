-- DISABLED
return {
  -- toggle git blame for each line in the current buffer  with <leader>gn
  "psjay/blamer.nvim",
  enabled = false,
  config = function()
    require("blamer").setup()
    vim.keymap.set("n", "<leader>gn", "<CMD>BlamerToggle<CR>")
  end,
}
