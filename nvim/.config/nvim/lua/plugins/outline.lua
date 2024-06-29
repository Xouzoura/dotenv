
return {
  -- Preview of the functions/classes on the right side of the screen (leader+a)
  "hedyhli/outline.nvim",
  lazy=false,
  config = function()
    -- Example mapping to toggle outline
    vim.keymap.set("n", "<leader>a", "<cmd>Outline<CR>",
      { desc = "Toggle Outline" })

    require("outline").setup {}
  end,
}
