-- using both diffview and vgit
return {
  {
    -- git view difference between two branches with <leader>gd and many keys there
    -- alternative to lazygit
    "sindrets/diffview.nvim",
    lazy = false,
    enabled = false,
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
  },
  {
    -- decide whether makes sense.
    "tanvirtin/vgit.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
    -- Lazy loading on 'VimEnter' event is necessary.
    event = "VimEnter",
    -- enabled = false,
    config = function()
      require("vgit").setup {
        keymaps = {
          -- ["n <leader>gr"] = function()
          --   require("vgit").buffer_hunk_reset()
          -- end,
          -- ["n <leader>gp"] = function()
          --   require("vgit").buffer_hunk_preview()
          -- end,
          -- ["n <leader>gbt"] = function()
          --   require("vgit").toggle_live_blame()
          -- end,
          -- ["n <leader>gbd"] = function()
          --   require("vgit").buffer_diff_preview()
          -- end,
          -- ["n <leader>gbh"] = function()
          --   require("vgit").buffer_history_preview()
          -- end,
          -- ["n <leader>gu"] = function()
          --   require("vgit").buffer_reset()
          -- end,
          -- ["n <leader>gd"] = function()
          --   require("vgit").project_diff_preview()
          -- end,
          -- ["n <leader>gx"] = function()
          --   require("vgit").toggle_diff_preference()
          -- end,
          ["n <"] = "hunk_up",
          ["n >"] = "hunk_down",

          ["n <leader>gbr"] = "buffer_hunk_reset",
          ["n <leader>gbs"] = "buffer_hunk_preview",
          ["n <leader>gbp"] = "buffer_blame_preview",
          ["n <leader>gbd"] = "buffer_diff_preview",
          ["n <leader>gbh"] = "buffer_history_preview",
          ["n <leader>gbu"] = "buffer_reset",
          ["n <leader>gd"] = "project_diff_preview",
          ["n <leader>gl"] = "project_logs_preview",
          -- ["n <leader>gx"] = "toggle_diff_preference",
          ["n <leader>gbt"] = "toggle_live_blame",
        },
        settings = { live_blame = { enabled = false } },
      }
    end,
  },
}
