return {
  {
    -- Plugin: nvim-tree.lua
    "nvim-tree/nvim-tree.lua",
    opts = function()
      local custom = require "nvchad.configs.nvimtree"
      custom.filters.dotfiles = false
      custom.git = custom.git or {}
      custom.git.ignore = false

      -- Add custom highlighting configuration
      custom.renderer = custom.renderer or {}
      custom.renderer.highlight_opened_files = "all"
      custom.renderer.icons = custom.renderer.icons or {}
      custom.renderer.icons.show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      }

      -- Configure to update focus when entering a buffer
      custom.update_focused_file = {
        enable = true,
        update_root = false,
        ignore_list = {},
      }

      -- Add custom highlighting colors
      vim.cmd [[
      highlight NvimTreeOpenedFile guifg=#8e7cc3
      highlight NvimTreeCursorLine guibg=#b4a7d6
    ]]

      return custom
    end,
  },
  -- More plugins
}
