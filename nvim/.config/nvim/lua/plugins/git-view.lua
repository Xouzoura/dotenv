-- using both diffview and vgit
-- Leaning towards more the diffview tbh
-- Key idea in mapping: b = buffer = file
-- 0: HEAD, 1: MAIN, 2: DEV
return {
  {
    "sindrets/diffview.nvim",
    -- lazy = true,
    config = function()
      local actions = require "diffview.actions"
      require("diffview").setup {
        keymaps = {
          file_panel = {
            -- TODO: add the scroll for god's sake with c-u and c-d

            { "n", "<C-b>", actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
            { "n", "<C-f>", actions.scroll_view(0.25), { desc = "Scroll the view down" } },
          },
        },
      }

      local map = vim.keymap.set

      -- <Keymaps>
      -- Project
      map("n", "<leader>gdh", "<cmd>DiffviewOpen<CR>", { desc = "(diffview) Diff with HEAD" })
      map("n", "<leader>gd2", "<cmd>DiffviewOpen develop..HEAD<CR>", { desc = "(diffview) Diff with dev" })
      map("n", "<leader>gd;", "<cmd>DiffviewClose<CR>", { desc = "(diffview) Close" })
      -- Buffer
      map("n", "<leader>gb2", "<cmd>DiffviewOpen develop -- %<CR>", { desc = "(diffview) Diff file with dev" })
      map("n", "<leader>gb0", "<cmd>DiffviewOpen HEAD -- %<CR>", { desc = "(diffview) Diff file with dev" })
      map("n", "<leader>gbf", "<cmd>DiffviewFileHistory %<CR>", { desc = "(diffview) Diff file" })
    end,
  },
  {
    "tanvirtin/vgit.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
    -- Lazy loading on 'VimEnter' event is necessary.
    event = "VimEnter",
    -- enabled = false,
    config = function()
      require("vgit").setup {
        keymaps = {
          ["n <"] = "hunk_up",
          ["n >"] = "hunk_down",
          -- Project
          ["n <leader>gdp"] = "project_diff_preview",
          ["n <leader>gl"] = "project_logs_preview",
          -- ["n <leader>gx"] = "toggle_diff_preference",
          -- Buffer
          ["n <leader>gbr"] = "buffer_hunk_reset",
          ["n <leader>gbs"] = "buffer_hunk_preview",
          ["n <leader>gbp"] = "buffer_blame_preview",
          ["n <leader>gbd"] = "buffer_diff_preview",
          ["n <leader>gbh"] = "buffer_history_preview",
          ["n <leader>gbu"] = "buffer_reset",
          ["n <leader>gbt"] = "toggle_live_blame",
        },
        settings = { live_blame = { enabled = false } },
      }
    end,
  },
}
