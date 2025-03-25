return {
  -- git view difference between two branches with <leader>gd and many keys there
  -- alternative to lazygit
  "sindrets/diffview.nvim",
  lazy = false,
  -- doesnt work at the moment
  -- TODO: add the scroll for god's sake with c-u and c-d
  -- opts = {
  --   keymaps = {
  --     file_panel = {
  --       { "n", "<c-b>", actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
  --       { "n", "<c-f>", actions.scroll_view(0.25), { desc = "Scroll the view down" } },
  --     },
  --   },
  -- },
}
