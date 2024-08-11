return {
  -- Plugin that creates directories etc
  "stevearc/oil.nvim",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    keymaps = {
      ["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
      ["<C-u>"] = { "actions.preview_scroll_up", desc = "Preview scroll up" },
      ["<C-d>"] = { "actions.preview_scroll_down", desc = "Preview scroll down" },
    },
    view_options = {
      show_hidden = true,
    },
  },
}
